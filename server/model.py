from __future__ import annotations
from pydantic import BaseModel


class User(BaseModel):
    email: str
    first_name: str
    last_name: str
    password: str
    birthday: str
    school: str
    grade: str
    difficulty: int = 0


class LoginSchema(BaseModel):
    email: str
    password: str


class DisplayUser(BaseModel):
    email: str
    first_name: str
    last_name: str
    birthday: str
    school: str
    grade: str
    difficulty: int

    @staticmethod
    def from_user(user: User) -> DisplayUser:
        return DisplayUser(**user.model_dump(exclude={"password"}))


class LoggedUser(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str
    user: DisplayUser


class RefreshScheme(BaseModel):
    refresh_token: str
