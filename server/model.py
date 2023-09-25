from __future__ import annotations
from datetime import datetime
from fastapi_camelcase import CamelModel


class User(CamelModel):
    email: str
    first_name: str
    last_name: str
    password: str
    birthday: str
    school: str
    grade: str
    difficulty: int = 0


class LoginSchema(CamelModel):
    email: str
    password: str


class DisplayUser(CamelModel):
    email: str
    first_name: str
    last_name: str
    birthday: datetime
    school: str
    grade: int
    difficulty: int

    @staticmethod
    def from_user(user: User) -> DisplayUser:
        user_dict = user.model_dump(exclude={"password"})

        return DisplayUser(**user_dict)


class RefreshScheme(CamelModel):
    refresh_token: str
