FROM tiangolo/uwsgi-nginx-flask:python3.6

WORKDIR /app


# copy over our app code
COPY ./app /app
# copy over our requirements.txt file
COPY . requirements.txt /app/

# upgrade pip and install required python packages
RUN pip install --upgrade pip==20.0.2 &&\
    pip install --trusted-host pypi.python.org -r requirements.txt


# set an environmental variable, MESSAGE,
# which the app will use and display
ENV MESSAGE "hello from Docker"

# Expose port 80
EXPOSE 80

# Run app.py at container launch
CMD ["python", "main.py"]