*** Settings ***
Library    Collections
Library    String
Library    RequestsLibrary
Resource    ../../resources/variables/environment.resource



*** Keywords ***
Disable SSL Warnings
    [Documentation]    Desactiva los warnings de SSL de urllib3
    Evaluate    __import__('urllib3').disable_warnings(__import__('urllib3').exceptions.InsecureRequestWarning)

Obtener Codigo OTP Mailsac
    [Arguments]    ${email_address}
    #    Configurar headers
    ${headers}=    Create Dictionary    Mailsac-Key=${MAILSAC_API_KEY}    Mailsac-Host=${MAILSAC_HOST}
    Create Session    mailsac    ${MAILSAC_BASE_URL}    headers=${headers}    verify=False
    #    Obtener mensajes
    ${response}=    GET On Session    mailsac    /addresses/${email_address}/messages
    Status Should Be    200    ${response}
    #    Obtener ID del mensaje mas reciente
    ${LAST_MESSAGE}=    Set Variable    ${response.json()[0]}
    ${message_id}=    Set Variable    ${LAST_MESSAGE['_id']}
    #    Obtener contenido del mensaje
    ${body_res}=    Get On Session    mailsac    /text/${email_address}/${message_id}
    #    Extraer codigo OTP del contenido
    ${OTP}=    Get Lines Matching Regexp    ${body_res.text}    \\d{6}
    RETURN    ${OTP}

