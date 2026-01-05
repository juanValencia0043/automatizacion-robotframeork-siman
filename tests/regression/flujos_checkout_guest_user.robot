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
# Test Checkout Small Ticket New User
#     [Tags]    CSC-8202  delivery_siman
#     Open Browser To Checkout    small 
#     Login Checkout  guest_user
#     Create New Adress In Checkout   new_user   Santa Ana    Santa Ana Centro    Santa Ana
#     Select Payment Method   transferencia_bancaria
#     Finish Purchase   verify

Test Checkout Split New User
    [Tags]    CSC-8202  split_siman 
    Open Browser To Checkout    split_siman 
    Login Checkout  guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase   verify

# Test Checkout Small Ticket Mk New User
#     [Tags]    CSC-8203  delivery_siman_mk
#     Open Browser To Checkout    small_mk
#     Login Checkout  guest_user
#     Create New Adress In Checkout   new_user   Santa Ana    Santa Ana Centro    Santa Ana
#     Select Payment Method   credisiman
#     Sleep    10s


# Test Checkout Big Ticket New User
#     [Tags]    CSC-8225  delivery_siman
#     Open Browser To Checkout    big 
#     Login Checkout  guest_user
#     Create New Adress In Checkout   new_user   San Salvador    San Salvador Centro    San Salvador
#     Select Payment Method   credisiman
#     Sleep    10s

    #Verify Order Confirmation

# Test Checkout Split New User
#     [Tags]    CSC-8226  delivery_and_pickup_siman
#     Open Browser To Checkout    split_siman 
#     Login Checkout  guest_user
#     Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV GALERIAS 
#     Select Payment Method   credisiman
#     Sleep    5s
#     #Verify Order Confirmation

#  Test Checkout Split Combinado New User
#     [Tags]    CSC-8227  delivery_and_pickup_siman_mk
#     Open Browser To Checkout    split_siman_mk 
#     Login Checkout  guest_user
#     Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV GALERIAS
#     Select Payment Method   credisiman
#     Sleep    5s

     #Verify Order Confirmation

