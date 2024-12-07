# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set the working directory inside the container
WORKDIR /app

# Set non-interactive mode for apt-get (to avoid prompts during installation)
ENV DEBIAN_FRONTEND=noninteractive

# Install Python, Java, and other required system dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev \
    openjdk-11-jdk \
    libjpeg-dev zlib1g-dev libssl-dev libffi-dev gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME and PATH for PySpark to use OpenJDK 11
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Copy only requirements to leverage Docker layer caching
COPY requirement.txt /app/requirement.txt

# Install Python dependencies for Flask and PySpark
RUN pip3 install --no-cache-dir -r /app/requirement.txt

# Copy the entire project directory into the container
COPY . /app

# Ensure the required CSV file is available inside the container
COPY final_data_drone.csv /app/final_data_drone.csv

# Expose the Flask app's port (change to 5020 as requested)
EXPOSE 5020

# Set the entrypoint to Python and the default command to run the Flask application
CMD ["python3", "app.py"]
