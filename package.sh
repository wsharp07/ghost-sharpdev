#!/bin/bash

# Variables
readonly DEPLOY_PATH="./deploy"
readonly STAGING_PATH="./ghost-sharpdev-theme"
CURRENT_VERSION=$(node -p "require('./package.json').version")
PACKAGE_NAME="ghost-sharpdev-theme-$CURRENT_VERSION.zip"
PACKAGE_PATH="$DEPLOY_PATH/$PACKAGE_NAME"


splash() {
    echo '
   _____ __                        ____  __             
  / ___// /_  ____ __________     / __ \/ /______ ______
  \__ \/ __ \/ __ `/ ___/ __ \   / /_/ / //_/ __ `/ ___/
 ___/ / / / / /_/ / /  / /_/ /  / ____/ ,< / /_/ / /    
/____/_/ /_/\__,_/_/  / .___/  /_/   /_/|_|\__, /_/     
                     /_/                  /____/        
'
}

create_directories() {
    mkdir -p $DEPLOY_PATH
    mkdir -p $STAGING_PATH
}

restore() {
    echo "Restoring NPM Packages"
    npm install

    echo "Building theme" 
    npm run-script build
}

stage() {
    echo "Staging files"
    cp -R "partials" $STAGING_PATH
    cp *.hbs $STAGING_PATH
    cp "package.json" $STAGING_PATH
    rsync -rR "assets/dist" $STAGING_PATH
}

package() {
    echo "Creating package '$PACKAGE_PATH'"
    rm -rf "$DEPLOY_PATH/*"
    zip -r "$PACKAGE_PATH" "$STAGING_PATH" 
}

cleanup() {
    echo "Cleaning up"
    rm -rf $STAGING_PATH
}

main() {
    splash
    create_directories
    restore
    stage
    package
    cleanup
}

### START ###
main