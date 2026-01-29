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
    [Arguments]    ${email_address}    ${max_reintentos}=3    ${tiempo_espera}=5s
    [Documentation]    Obtiene el código OTP del correo en Mailsac
    ...    Reintentos automáticos si no encuentra el correo o código OTP válido
    ...    Argumentos:
    ...    - email_address: Dirección de correo de Mailsac
    ...    - max_reintentos: Número máximo de reintentos (default: 3)
    ...    - tiempo_espera: Tiempo a esperar entre intentos (default: 60s)
    
    ${headers}=    Create Dictionary    Mailsac-Key=${MAILSAC_API_KEY}    Mailsac-Host=${MAILSAC_HOST}
    ${intentos}=    Set Variable    0

    FOR    ${intentos}    IN RANGE    ${max_reintentos}
        Sleep    ${tiempo_espera}
        Log To Console    Intento número: ${intentos + 1}
        Create Session    mailsac    ${MAILSAC_BASE_URL}    headers=${headers}
        ${response}=    GET On Session    mailsac    /addresses/${email_address}/messages
        Status Should Be    ${response}    200
        IF    '${response.json()}' == '[]'
            Log To Console    No se encontraron correos. Esperando ${tiempo_espera} antes del siguiente intento...
            CONTINUE
        END
    END    
    ${messages}=    Set Variable    ${response.json()}
    ${latest_message}=    Get From List    ${messages}    0
    ${message_id}=    Get From Dictionary    ${latest_message}    _id
    Log To Console    ID del último mensaje: ${message_id}
    #    Obtener el contenido del correo
    ${body_res}=    GET On Session    mailsac    /text/${email_address}/${message_id}
    Status Should Be    ${body_res}    200
    ${otp}=    Get Lines Matching Regexp    ${body_res.text}    \\d{6}
    Log To Console    Código OTP obtenido: ${otp}
    RETURN    ${otp}


    

