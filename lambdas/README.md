Data is loaded into snowflake via Lambda functions

Testing Functions

1. docker build -t myfunction:latest .

2. docker run -p 9000:8080  myfunction:latest 

3. curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'