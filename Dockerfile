# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create a non-root user and switch to it
RUN useradd -m appuser
USER appuser

# Set the working directory to /app
WORKDIR /app

# Copy the requirements.txt file into the container at /app/
COPY requirements.txt /app/

# Create a virtual environment and activate it
RUN python -m venv venv && source venv/Scripts/activate

# Install any needed packages specified in requirements.txt
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . /app

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Switch back to root temporarily to apply migrations
USER root

# Apply database migrations when the container starts
CMD ["sh", "-c", "python src/PetsFinder/manage.py migrate && python src/PetsFinder/manage.py runserver 0.0.0.0:8000"]
