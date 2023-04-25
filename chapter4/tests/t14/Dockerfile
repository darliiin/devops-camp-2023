# Compile
FROM python:3-slim AS build-env
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt

# Deploy
FROM gcr.io/distroless/python3:debug
WORKDIR /app
COPY --from=build-env /app /app
COPY --from=build-env /usr/local/ /usr/local

ENTRYPOINT [ "python", "memory.py" ]
