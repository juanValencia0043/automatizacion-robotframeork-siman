*** Settings ***
Library    SeleniumLibrary
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/locators/checkout_locators.resource
Resource    ../../resources/variables/testdata.resource

*** Keywords ***
Login Checkout
    [Arguments]    ${user_type}
    [Documentation]    Metodo general para logearse en checkout ya sea como usuario recurrente o no 
    
    Click Element By Type   ${BTN_GO_PAYMENT}    button

    # Espera específica para el campo de email
    Wait Until Element Is Visible    ${INPUT_NAME}    30s
    Wait Until Element Is Enabled    ${INPUT_NAME}    10s
    
    IF    '${user_type}' == 'new_user'
        ${random_email}    Create Random Email
        Fill Element By Text    ${INPUT_EMAIL}    ${random_email}
        Click Element By Type    ${INPUT_NAME}    other
        Fill Element By Text    ${INPUT_NAME}    ${NAME}
        Fill Element By Text    ${INPUT_LAST_NAME}    ${LAST_NAME}
        Select List Item    ${SELECT_DOCUMENT}    ${DUI}
        Fill Element By Text    ${INPUT_DOCUMENT}     ${DOCUMENT}
        Fill Element By Text    ${INPUT_PHONE}    ${PHONE}
        Click Element By Type    ${CHECK_PRIVACY_TERMS}    checkbox
        Click Element By Type   ${BTN_GO_SHIPPING}    button        
    ELSE IF    '${user_type}' == 'recurrent_user'
        Fill Element By Text    ${INPUT_EMAIL}    ${EMAIL_RECURRENT}
    END

Create New Adress In Checkout
    [Arguments]    ${user_type}    ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}
    [Documentation]    Metodo para crear una nueva direccion en el checkout

    # Espera específica para el campo de email
    Wait Until Element Is Visible    ${SELECT_DEPARMENT}    30s
    Wait Until Element Is Enabled    ${SELECT_DEPARMENT}    10s 

    IF    '${user_type}' == 'new_user'
        Select List Item    ${SELECT_DEPARMENT}    ${DEPARTMENT}
        Select List Item    ${SELECT_CITY}    ${CITY}
        Select List Item    ${SELECT_NEIGHBORHOOD}    ${NEIGHBORHOOD}
        Fill Element By Text    ${INPUT_STREET}    Test Street
        Fill Element By Text    ${INPUT_COMPLEMENT}    Apto 123
        Fill Element By Text    ${INPUT_RECEIVER_NAME}    User Test
        Click Element By Type    ${BTN_GO_PAYMENT_SHIPPING}    button
    ELSE IF   '${user_type}' == 'recurrent_user'
        Click Element By Type    ${BTN_NEW_ADDRESS_OPTION}    button
        Select List Item    ${SELECT_DEPARMENT}    ${DEPARTMENT}
        Select List Item    ${SELECT_CITY}    ${CITY}
        Select List Item    ${SELECT_NEIGHBORHOOD}    ${NEIGHBORHOOD}
        Fill Element By Text    ${INPUT_STREET}    Test Street
        Fill Element By Text    ${INPUT_COMPLEMENT}    Apto 123
        Fill Element By Text    ${INPUT_RECEIVER_NAME}    User Test
        Click Element By Type    ${BTN_GO_PAYMENT_SHIPPING}    button
    END

Select Payment Method
    [Arguments]    ${payment_method}
    [Documentation]    Selección de método de pago en checkout

    Sleep    1s 

    IF    '${payment_method}' == 'credisiman'
        # Lógica para seleccionar tarjeta de crédito
        Click Element By Type    ${paymentgroupcustomPrivate3Locator}    button
        Sleep   5s

    ELSE IF    '${payment_method}' == 'credisiman cuotas'
        # Lógica para seleccionar PayPal
        Log To Console    Seleccionando pago con credisiman cuotas

    ELSE IF   '${payment_method}' == 'credisiman cuotas intereses'
        # Lógica para seleccionar transferencia bancaria
        Log To Console    Seleccionando pago con credisiman cuotas intereses

    ELSE IF    '${payment_method}' == 'credisiman visa'
        # Lógica para seleccionar PayPal
        Log To Console    Seleccionando pago con credisiman visa

    ELSE IF   '${payment_method}' == 'tarjeta credito debito'
        # Lógica para seleccionar transferencia bancaria
        Log To Console    Seleccionando pago con tarjeta credito debito
    END



