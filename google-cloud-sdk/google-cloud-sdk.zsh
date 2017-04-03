export GOOGLE_CLOUD_SDK=$HOME/code/github/google-cloud-sdk

if [ -d "$GOOGLE_CLOUD_SDK" ]; then
  # Update PATH for the Google Cloud SDK.
  source $GOOGLE_CLOUD_SDK/path.zsh.inc

  # Enable zsh completion for gcloud.
  source $GOOGLE_CLOUD_SDK/completion.zsh.inc

  alias goapp=$GOOGLE_CLOUD_SDK/platform/google_appengine/goapp
fi
