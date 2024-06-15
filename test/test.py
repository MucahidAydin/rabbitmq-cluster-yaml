from celery import Celery  # pip install celery


def send_data_to_rabbitmq(data):
    user = "admin"
    password = "admin"

    rabbitmq_queue = Celery(
        "tasks", broker=f"amqp://{user}:{password}@localhost:5672//"
    )
    result = rabbitmq_queue.send_task("tasks.test_worker", args=[data])
    if not result:
        print("Failed to send data to RabbitMQ!")
    else:
        print("Data is sent to RabbitMQ!")


if __name__ == "__main__":
    data = {
        "test": "rabbitmq",
    }
    for i in range(100):
        send_data_to_rabbitmq(data)
