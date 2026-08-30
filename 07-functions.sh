#!/bin/bash

echo "==================================="
echo "       DEVOPS LEARNING PLAN"
echo "==================================="

learn_topic() {
    echo "Topic                     : $1"
    echo "Objective                 : $2"
    echo "Mode of learning          : $3"
    echo "No of Productivity hours  : $4"
}

learn_tools() {
    echo "Number of tools: $#"

    for tool in "$@"
    do
        echo "Checking tool: $tool"
    done
}

echo
echo "LEARNING TOPICS"

learn_topic "Cloud"    "AWS, Azure, GCP" "Online" "40 hr"
learn_topic "Linux"    "Bash Shell Scripting" "Online" "30 hr"
learn_topic "Git"      "DVCS, Branching and Commands" "Online" "25 hr"
learn_topic "Maven"    "Compile, Build, Test and Package" "Online" "15 hr"
learn_topic "Jenkins"  "Continuous Integration and Delivery" "Online" "20 hr"

echo
echo "DEVOPS TOOLS"

learn_tools "Git" "Maven" "Jenkins" "Docker" "Kubernetes"

echo
echo "==================================="
