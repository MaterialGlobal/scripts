#!/bin/bash
touch /home/container/.installstate
installstate=$(cat /home/container/.installstate)

# Tell the user that their image is incorrect
function image_fail() {
    echo "Please set the correct Docker Image in the Startup tab of your server. If you wish to run NodeJS apps, choose one of the latest NodeJS images, etc."
    echo "If you have any questions or concerns, don't hesitate to contact Nexus Compute support via the Billing Portal or our official Discord Server."
    echo "The program will now exit. Have a nice day!"
}

# Warn the user about the Docker Image setting for Java
function warn_java() {
    echo "WARNING: Please ensure the Docker Image in the Startup tab is set to one of the Java images."
    echo "WARNING: Otherwise, your App Container will not run at all."
    read -p "Type 'yes' if it's set to Java or 'no' if it's not: " option
    case $option in
        yes) run_java ;;
        no) image_fail ;;
        *) echo "Invalid option. Exiting." ;;
    esac
}

# Warn the user about the Docker Image setting for NodeJS
function warn_node() {
    echo "WARNING: Please ensure the Docker Image in the Startup tab is set to one of the NodeJS images."
    echo "WARNING: Otherwise, your App Container will not run at all."
    read -p "Type 'yes' if it's set to NodeJS or 'no' if it's not: " option
    case $option in
        yes) run_node ;;
        no) image_fail ;;
        *) echo "Invalid option. Exiting." ;;
    esac
}

# Warn the user about the Docker Image setting for Python
function warn_python() {
    echo "WARNING: Please ensure the Docker Image in the Startup tab is set to one of the Python images."
    echo "WARNING: Otherwise, your App Container will not run at all."
    read -p "Type 'yes' if it's set to Python or 'no' if it's not: " option
    case $option in
        yes) run_python ;;
        no) image_fail ;;
        *) echo "Invalid option. Exiting." ;;
    esac
}

# Function to run the Java command
function run_java() {
    java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true -jar ${JARFILE}
}

# Function to run the Node.js command
function run_node() {
    if [[ -d .git ]]; then git pull; fi
    if [[ ! -z "${NODE_PACKAGES}" ]]; then /usr/local/bin/npm install ${NODE_PACKAGES}; fi
    if [ -f /home/container/package.json ]; then /usr/local/bin/npm install; fi
    /usr/local/bin/node /home/container/{{JS_FILE}}
}

# Function to run the Python command
function run_python() {
    if [[ -d .git ]] && [[ "{{AUTO_UPDATE}}" == "1" ]]; then git pull; fi
    if [[ ! -z "${PY_PACKAGES}" ]]; then pip install -U --prefix .local ${PY_PACKAGES}; fi
    if [[ -f /home/container/${REQUIREMENTS_FILE} ]]; then pip install -U --prefix .local -r ${REQUIREMENTS_FILE}; fi
    /usr/local/bin/python /home/container/{{PY_FILE}}
}

if [ $installstate == "java" ]; then
    run_java()
fi

if [ $installstate == "node" ]; then
    run_node()
fi

if [ $installstate == "python" ]; then
    run_python()
fi

# Menu options
echo "What software would you like to run on your App Container?"
echo "This will only be asked once after installation."
echo "1) Run Java"
echo "2) Run NodeJS"
echo "3) Run Python"

# Read user input
read -p "Enter option number: " option

# Execute the selected option
case $option in
    1) echo "java" > /home/container/.installstate && warn_java ;;
    2) echo "node" > /home/container/.installstate && warn_node ;;
    3) echo "python" > /home/container/.installstate && warn_python ;;
    *) echo "Invalid option. Exiting." ;;
esac
