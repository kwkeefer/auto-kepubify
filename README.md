# kepmatic

This is a fairly simple docker compose setup that uses watches a source directory for epub files, uses [kepubify](https://github.com/pgaskin/kepubify) to convert these files into a .kepub file.  Then [rclone](https://github.com/rclone/rclone) is used to sync these files to a remote such as Dropbox.

## .env file setup

Copy `example.env` to `.env`

Replace `USER_ID` and `GROUP_ID` with values that can read/write to your SOURCE_DIRECTORY and SYNC_DIRECTORY.

`COPY_ALL` can be set to `true` to copy all files to the remote source.  Note that folder structures will NOT be copied, so there is a chance of name collisions.

Replace `SOURCE_DIRECTORY` with an absolute path to the directory where .epub files will be saved to.

Replace `SYNC_DIRECTORY` with a directory that the kepub files will be copied to.  Files in this directory will be synced to Dropbox and then deleted.

`REMOTE_DIRECTORY` is the directory that files will be copied to in the rclone remote (eg Dropbox).  This should be `"Apps/Rakuten Kobo"` for Dropbox and `"Rakuten Kobo"` for Google Drive.

## rclone setup

### Generate the rclone config file

You can either create a config file by installing rclone and running `rclone config`.  The instrucions below do it via Docker to avoid installing rclone. 

Build and run the container (assumes you are running L)
```
source .env
docker build -t rclone-auth -f rclone/rclone-auth.Dockerfile .
docker run -v $PWD/rclone/config:/config:z --user $USER_ID:$GROUP_ID -p 53682:53682 -ti --entrypoint bash rclone-auth
```

Inside the container, run `rclone config` and select the following:
```
# dropbox
new remote
name: remote
storage: dropbox
empty client_id
empty client_secret
no advanced config
yes web browser
click on the link or paste into your browser
keep the new dropbox remote
quit the config


# google drive
new remote
name: remote
storage: drive
empty client_id
empty_client secret
scope 1
empty service account file
no advanced config
click on the link or paste into your browser
no shared drive
keep the new dropbox remote
quit the config
```

While still inside the container, copy the file to your host:

```
cp ~/.config/rclone/rclone.conf /config/
```

## Run the services

```
docker compose build
docker compose up 
```


