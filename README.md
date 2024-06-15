# RabbitMQ Cluster with HAProxy

This project sets up a RabbitMQ cluster with HAProxy for load balancing using Docker Compose. The cluster consists of six RabbitMQ nodes and one HAProxy instance.

## Prerequisites

- Docker
- Docker Compose

## Environment Variables

Create a `.env` file in the root of your project with the following content:

```env
RABBITMQ_DEFAULT_USER=your_username
RABBITMQ_DEFAULT_PASS=your_password
```

## Running the Cluster
To start the RabbitMQ cluster with HAProxy, run the following command in the root of your project:
```bash
docker-compose up -d
```
This will start the RabbitMQ nodes and HAProxy in detached mode.

## Accessing RabbitMQ Management
You can access the RabbitMQ Management UI at http://localhost:15672. Use the credentials specified in the .env file.
 
## RabbitMQ Management UI - Overview
![RabbitMQ Management UI - Overview](/image/image-1.png)

## RabbitMQ Management UI - Queue
![RabbitMQ Management UI - Queue](/image/image-2.png)


## Testing the RabbitMQ Cluster
To test the RabbitMQ cluster, you can run the following command to create a queue:

```bash
python3 test/test.py
```