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
    birthday: str
    school: str
    grade: str
    difficulty: int

    @staticmethod
    def from_user(user: User) -> DisplayUser:
        return DisplayUser(
            email=user.email,
            first_name=user.first_name,
            last_name=user.last_name,
            birthday=user.birthday,
            school=user.school,
            grade=user.grade,
            difficulty=user.difficulty,
        )


class RefreshScheme(CamelModel):
    refresh_token: str
