from datetime import datetime, timedelta
from typing import Annotated, List

import jwt
from fastapi import FastAPI, Header, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from model import DisplayUser, UserWithTokens, LoginSchema, SessionData, User, RefreshScheme

app = FastAPI()

# Create a list to store users
users_db: List[User] = []

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define an endpoint to register a user
@app.post("/register")
async def register(data: User) -> UserWithTokens:
    print(data)

    for user in users_db:
        if user.email == data.email:
            raise HTTPException(status_code=400, detail="Username already registered")

    users_db.append(data)

    return do_login(data)


# Define an endpoint to list all users
@app.get("/users")
async def list_users() -> List[DisplayUser]:
    return [DisplayUser.from_user(user) for user in users_db]


# Deletes all user
@app.post("/delete-all")
def delete_all():
    users_db.clear()

    return {"message": "All users deleted"}


# Define JWT settings
JWT_SECRET = "supersecret"
JWT_ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30
REFRESH_TOKEN_EXPIRE_MINUTES = 1440


# Define a function to authenticate a user with a given username and password
def get_user(username: str) -> User | None:
    return next((user for user in users_db if user.email == username), None)


# Define a function to authenticate a user with a given username and password
def authenticate_user(username: str, password: str) -> User:
    user = get_user(username)

    if user and user.password == password:
        return user

    raise HTTPException(status_code=401, detail="Invalid username or password")


def do_login(user: User) -> UserWithTokens:
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    refresh_token_expires = timedelta(minutes=REFRESH_TOKEN_EXPIRE_MINUTES)

    access_token = jwt.encode(
        {"sub": user.email, "exp": datetime.utcnow() + access_token_expires},
        JWT_SECRET,
        algorithm=JWT_ALGORITHM,
    )

    refresh_token = jwt.encode(
        {"sub": user.email, "exp": datetime.utcnow() + refresh_token_expires},
        JWT_SECRET,
        algorithm=JWT_ALGORITHM,
    )

    return UserWithTokens(
        access_token=access_token,
        refresh_token=refresh_token,
        token_type="bearer",
        user=DisplayUser.from_user(user),
    )


# Define an endpoint to create a new access token and refresh token
@app.post("/login")
async def login(data: LoginSchema):
    user = authenticate_user(data.email, data.password)

    return do_login(user)


# Gets the currently logged in user
def current_user(authorization: Annotated[str | None, Header()] = None) -> User:
    if authorization is None:
        raise HTTPException(status_code=401, detail="Invalid authorization header")
    try:
        token = authorization.split(" ")[1]
        decoded_token = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        username = decoded_token["sub"]

        for user in users_db:
            if user.email == username:
                return user

        raise HTTPException(status_code=401, detail="User does not exist")
    except Exception as e:
        print(e)

        raise HTTPException(status_code=401, detail="Invalid token")


# Sets a new base difficulty for the user
@app.patch("/update")
async def update(
    session_data: SessionData, authorization: Annotated[str | None, Header()] = None
) -> DisplayUser:
    user = current_user(authorization)
    user.difficulty = session_data.difficulty
    user.history = session_data.history
    user.updated_at = datetime.now()

    return DisplayUser.from_user(user)


# Gets the current user's data
@app.get("/me")
async def me(authorization: Annotated[str | None, Header()] = None) -> DisplayUser:
    user = current_user(authorization)

    return DisplayUser.from_user(user)


# Define an endpoint to refresh an access token with a refresh token
@app.post("/refresh")
async def refresh_token(data: RefreshScheme) -> UserWithTokens:
    try:
        print(data.model_dump())

        decoded_token = jwt.decode(
            data.refresh_token, JWT_SECRET, algorithms=[JWT_ALGORITHM]
        )

        username = decoded_token["sub"]
        access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

        access_token = jwt.encode(
            {"sub": username, "exp": datetime.utcnow() + access_token_expires},
            JWT_SECRET,
            algorithm=JWT_ALGORITHM,
        )

        user = get_user(username)

        if not user:
            raise HTTPException(status_code=401, detail="User does not exist")

        return UserWithTokens(
            access_token=access_token,
            refresh_token=data.refresh_token,
            user=DisplayUser.from_user(user),
        )
    except Exception as e:
        print(e)

        raise HTTPException(status_code=401, detail="Invalid refresh token")
