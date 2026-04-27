from fastapi import FastAPI

app = FastAPI()

@app.get("/api")
def root():
    return {"message": "FastAPI is running!", "service": "api"}

@app.get("/api/health")
def health():
    return {"status": "healthy"}
