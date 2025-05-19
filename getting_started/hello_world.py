# SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from fastapi import FastAPI
from pydantic import BaseModel

from dynamo.sdk import dynamo_endpoint, service


"""
Pipeline Architecture:

Users/Clients (HTTP)
      │
      ▼
┌─────────────┐
│  MyService  │  HTTP API endpoint (/generate)
└─────────────┘
"""


class RequestType(BaseModel):
    text: str

app = FastAPI(title="My App")

@service(
    dynamo={"enabled": True, "namespace": "my_namespace"},
    app=app,
)
class MyService:
    @dynamo_endpoint(is_api=True)
    async def generate(self, request: RequestType):
        return f"Hello, {request.text}!"
