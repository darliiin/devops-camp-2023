# Compile
FROM python:3-slim AS build-env
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt

#Deploy
FROM gcr.io/distroless/python3:3.
WORKDIR /app
COPY --from=build-env /app /app
COPY --from=build-env /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
ENV PYTHONPATH=/usr/local/lib/python3.11/site-packages
ENTRYPOINT [ "python", "memory.py" ]
