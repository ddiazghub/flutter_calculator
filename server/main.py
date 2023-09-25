from datetime import datetime, timedelta
from typing import Annotated, List

import jwt
from fastapi import FastAPI, Header, HTTPException
from model import DisplayUser, LoginSchema, User, RefreshScheme

app = FastAPI()

# Create a list to store users
users_db: List[User] = []


# Define an endpoint to register a user
@app.post("/register")
async def register(data: User) -> DisplayUser:
    for user in users_db:
        if user.username == data.username:
            raise HTTPException(status_code=400, detail="Username already registered")

    users_db.append(data)

    return DisplayUser.from_user(data)

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
def authenticate_user(username: str, password: str):
    for user in users_db:
        if user.username == username:
            if user.password == password:
                return user
            else:
                raise HTTPException(
                    status_code=401, detail="Invalid username or password"
                )

    raise HTTPException(status_code=401, detail="Invalid username or password")


# Define an endpoint to create a new access token and refresh token
@app.post("/login")
async def login(data: LoginSchema):
    user = authenticate_user(data.username, data.password)
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    refresh_token_expires = timedelta(minutes=REFRESH_TOKEN_EXPIRE_MINUTES)

    access_token = jwt.encode(
        {"sub": user.username, "exp": datetime.utcnow() + access_token_expires},
        JWT_SECRET,
        algorithm=JWT_ALGORITHM,
    )

    refresh_token = jwt.encode(
        {"sub": user.username, "exp": datetime.utcnow() + refresh_token_expires},
        JWT_SECRET,
        algorithm=JWT_ALGORITHM,
    )

    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer",
        "user": user.model_dump(exclude={"password"})
    }


# Gets the currently logged in user
def current_user(authorization: Annotated[str | None, Header()] = None) -> User:
    if authorization is None:
        raise HTTPException(status_code=401, detail="Invalid authorization header")
    try:
        token = authorization.split(" ")[1]
        decoded_token = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        username = decoded_token["sub"]

        for user in users_db:
            if user.username == username:
                return user

        raise HTTPException(status_code=401, detail="User does not exist")
    except Exception as e:
        print(e)

        raise HTTPException(status_code=401, detail="Invalid token")


# Sets a new base difficulty for the user
@app.patch("/levelup")
async def levelup(difficulty: int, authorization: Annotated[str | None, Header()] = None) -> DisplayUser:
    user = current_user(authorization)
    user.difficulty = difficulty

    return DisplayUser.from_user(user)


# Gets the current user's data
@app.get("/me")
async def me(authorization: Annotated[str | None, Header()] = None) -> DisplayUser:
    user = current_user(authorization)

    return DisplayUser.from_user(user)


# Define an endpoint to refresh an access token with a refresh token
@app.post("/refresh")
async def refresh_token(data: RefreshScheme):
    try:
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

        return {"access_token": access_token, "token_type": "bearer"}
    except Exception as e:
        print(e)

        raise HTTPException(status_code=401, detail="Invalid refresh token")
