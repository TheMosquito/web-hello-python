# web-hello-python
Extremely simple HTTP server (written in Python) that responds on port 8000 with a hello message.

Begin by editing the variables at the top of the Makefile as desired. If you plan to push it to a Docker registery, make sure you give your docker ID. You may also want to create unique names for your **service** and **pattern** (necessary if you are sharing a tenancy with other users and you are all publishing this service).

To play with this outside of Open Horizon:

```
make build
make run
...
make test
make stop
```

When you are ready to try it inside Open Horizon:

```
docker login
hzn key create **yourcompany** **youremail**
make build
make push
make publish-service
make publish-patterrn
```

Once it is published, you can use:

```
make register-pattern
watch hzn agreement list
...
make test
```
