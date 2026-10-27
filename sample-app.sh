#!/bin/bash
set -e

cd "$(dirname "$0")"
rm -rf tempdir
mkdir -p tempdir/templates tempdir/static

cp sample_app.py tempdir/
cp -r templates/. tempdir/templates/
cp -r static/. tempdir/static/

cat > tempdir/Dockerfile <<'EOF'
FROM python:3.12-slim
RUN pip install --no-cache-dir flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 5050
CMD ["python", "/home/myapp/sample_app.py"]
EOF

docker build -t sampleapp tempdir
docker rm -f samplerunning 2>/dev/null || true
docker run -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a