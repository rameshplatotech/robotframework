*** Settings ***
Resource    ../../resources/variables/variables.robot
Resource    ../../resources/keywords/api_keywords.robot
Library     Collections
Library     RequestsLibrary

*** Test Cases ***
Dummy REST Employee GET Returns Data Or 429
    Create API Session    alias=dummy    base_url=${DUMMY_REST_API_BASE_URL}
    ${response}=    Send GET Request    /employee/1    expected_status=any    alias=dummy
    ${status}=    Set Variable    ${response.status_code}
    Should Be True    ${status} == 200 or ${status} == 429
    Run Keyword If    ${status} == 200    Validate Dummy Employee Success Response    ${response}
    Run Keyword If    ${status} == 429    Validate Dummy Employee Rate Limit Response    ${response}

*** Keywords ***
Validate Dummy Employee Success Response
    [Arguments]    ${response}
    ${actual}=    Evaluate    $response.json()
    ${expected_data}=    Create Dictionary    id=1    employee_name=Tiger Nixon    employee_salary=320800    employee_age=61    profile_image=
    ${expected}=    Create Dictionary    status=success    data=${expected_data}    message=Successfully! Record has been fetched.
    Dictionaries Should Be Equal    ${actual}    ${expected}

Validate Dummy Employee Rate Limit Response
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    429
