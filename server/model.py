from __future__ import annotations
from pydantic import BaseModel


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

    @staticmethod
    def from_user(user: User) -> DisplayUser:
        return DisplayUser(**user.model_dump(exclude={"password"}))


class SessionData(BaseModel):
    difficulty: int
    history: list[Session]


class LoggedUser(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str
    user: DisplayUser


class RefreshScheme(BaseModel):
    refresh_token: str
