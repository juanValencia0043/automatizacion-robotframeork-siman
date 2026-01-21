*** Settings ***
Documentation    Verifica flujos principales en Checkout.

Resource    ../../resources/keywords/browser_keywords.resource
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/keywords/checkout_keywords.resource

Resource    ../../resources/variables/environment.resource
Resource    ../../resources/variables/checkout_urls.resource

Resource    ../../resources/locators/home_locators.resource
Resource    ../../resources/locators/checkout_locators.resource


Test Teardown   Close Browser

*** Test Cases ***
Test Checkout Small Ticket New User
    #FINALIZADO
    [Tags]    CSC-8202  delivery_siman
    Open Browser To Checkout    small 
    Login Checkout  guest_user
    Create New Adress In Checkout   new_user   Santa Ana    Santa Ana Centro    Santa Ana
    Select Payment Method   transferencia_bancaria
    Finish Purchase   no_verify

Test Checkout Split Siman Guest User
    #FINALIZADO
    [Tags]    CSC-8202  split_siman SmallTicket BigTicket guest_user
    Open Browser To Checkout    split_siman 
    Login Checkout  guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split Siman New User    
    #FINALIZADO
    [Tags]    CSC-8202  split_siman_new_user 
    Open Browser To Checkout    split_siman 
    Login Checkout  new_user    
    #Create New Adress In Checkout   new_user   San Salvador    San Salvador Centro    San Salvador
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split Siman Recurrent User
    #IN PROGRESS
    [Tags]    CSC-8202  split_siman_recurrent_user 
    Open Browser To Checkout    split_siman 
    Login Checkout  recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK Guest User
    [Tags]    CSC-8202  split_siman_mk 
    Open Browser To Checkout    split_siman_mk 
    Login Checkout  guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK New User
    [Tags]    CSC-8202  split_siman_mk_new_user 
    Open Browser To Checkout    split_siman_mk 
    Login Checkout  new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK Recurrent User
    [Tags]    CSC-8202  split_siman_mk_recurrent_user
    Open Browser To Checkout    split_siman_mk 
    Login Checkout  recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify



# Test Checkout Small Ticket Mk New User
#     [Tags]    CSC-8203  delivery_siman_mk
#     Open Browser To Checkout    small_mk
#     Login Checkout  guest_user
#     Create New Adress In Checkout   new_user   Santa Ana    Santa Ana Centro    Santa Ana
#     Select Payment Method   credisiman
#     Finish Purchase  no verify


# Test Checkout Big Ticket New User
#     [Tags]    CSC-8225  delivery_siman
#     Open Browser To Checkout    big 
#     Login Checkout  guest_user
#     Create New Adress In Checkout   new_user   San Salvador    San Salvador Centro    San Salvador
#     Select Payment Method   credisiman
#     Finish Purchase  no verify

#     #Verify Order Confirmation

# Test Checkout Split New User
#     [Tags]    CSC-8226  delivery_and_pickup_siman
#     Open Browser To Checkout    split_siman 
#     Login Checkout  guest_user
#     Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV GALERIAS 
#     Select Payment Method   credisiman
#     Finish Purchase  no verify
#     #Verify Order Confirmation

#  Test Checkout Split Combinado New User
#     [Tags]    CSC-8227  delivery_and_pickup_siman_mk
#     Open Browser To Checkout    split_siman_mk 
#     Login Checkout  guest_user
#     Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV GALERIAS
#     Select Payment Method   credisiman
#     Finish Purchase  no verify

#      #Verify Order Confirmation

