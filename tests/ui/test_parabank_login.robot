*** Settings ***
Resource    ../../resources/variables/variables.robot
Resource    ../../resources/keywords/ui_keywords.robot
Test Teardown    Close Browser Session

*** Test Cases ***
User Can Login To Parabank
    Open Parabank Home
    Attach UI Snapshot    Parabank Login Page
    Login To Parabank    ${PARABANK_USERNAME}    ${PARABANK_PASSWORD}

