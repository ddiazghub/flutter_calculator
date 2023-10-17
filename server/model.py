from __future__ import annotations
from pydantic import BaseModel
from datetime import datetime


class Question(BaseModel):
    question: str
    expected: int
    answer: int


class Session(BaseModel):
    total_time: int
    correct: int
    questions: list[Question]


class User(BaseModel):
    email: str
    first_name: str
    last_name: str
    password: str
    birthday: str
    school: str
    grade: str
    difficulty: int = 0
    history: list[Session] = []
    updated_at: datetime = datetime.now()
    

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
    history: list[Session]
    updated_at: datetime

    @staticmethod
    def from_user(user: User) -> DisplayUser:
        return DisplayUser(**user.model_dump(exclude={"password"}))


class SessionData(BaseModel):
    difficulty: int
    history: list[Session]


class UserWithTokens(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user: DisplayUser


class RefreshScheme(BaseModel):
    refresh_token: str
