from prefect import task, flow, get_run_logger

@task
def get_data():
    return [1, 2, 3, 4, 5, 6, 7]

@task
def print_data(data):
    get_run_logger().info(f"This is your data: {data}!")

@flow()
def my_data_flow():
    data = get_data()
    print_data(data)

if __name__ == "__main__":
    my_data_flow()