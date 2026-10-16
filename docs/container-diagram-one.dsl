workspace "Eventify IoT Solution" "Container Diagram for the Eventify IoT Solution" {

    !identifiers hierarchical

    model {

        // =========================================================
        // USERS
        // =========================================================

        attendee = person "Registered Person / Attendee" {
            description "Uses the Eventify mobile application to obtain the event QR code and becomes an attendee after successful check-in."
        }

        checkInStaff = person "Check-In Staff" {
            description "Operates a check-in station to validate QR codes and activate and assign RFID bands."
        }

        organizer = person "Event Organizer" {
            description "Configures event information, uploads registered people and reviews event analytics."
        }

        foodPartnerUser = person "Food Partner User" {
            description "Monitors product and ingredient inventory for Smart Food Dispensers and Smart Coffee Makers."
        }

        maintenanceAgent = person "Technical Support Agent" {
            description "Uses the maintenance mobile application to perform preventive and corrective maintenance during events."
        }

        maintenanceOffice = person "Maintenance Partner Office Staff" {
            description "Uses the maintenance web platform to monitor device status across assigned events."
        }


        // =========================================================
        // EXTERNAL SYSTEMS
        // =========================================================

        foodPartnerSystem = softwareSystem "Food Partner Internal System" {
            description "Internal system of the food supplier that integrates with Eventify through the REST API."
        }

        maintenancePartnerSystem = softwareSystem "Maintenance Partner Internal System" {
            description "Internal system of the maintenance partner that integrates with Eventify through the REST API."
        }


        // =========================================================
        // EVENTIFY IOT SOLUTION
        // =========================================================

        eventify = softwareSystem "Eventify IoT Solution" {
            description "IoT platform for event registration, access, RFID-based consumption, device monitoring, inventory management and centralized event management."


            // =====================================================
            // EVENT DEVICE FIRMWARE
            // =====================================================

            foodDispenserFirmware = container "Smart Food Dispenser Firmware" {
                description "Embedded software running on the ESP32 of each Smart Food Dispenser. Reads RFID bands, monitors four DHT-22 temperature sensors, manages stock information and controls twenty micro servo motors used for product dispensing."
                technology "ESP32 Embedded Firmware"
                tags "Firmware"
            }

            coffeeMakerFirmware = container "Smart Coffee Maker Firmware" {
                description "Embedded software running on the ESP32 of each Smart Coffee Maker. Reads RFID bands, monitors the DHT-22 temperature sensor, manages ingredient stock and controls four micro servo motors used by the dispensing mechanism."
                technology "ESP32 Embedded Firmware"
                tags "Firmware"
            }


            // =====================================================
            // EVENT EDGE
            // =====================================================

            edgeService = container "Event Edge Processing Service" {
                description "Software running on the processing server located at the event control station. Centralizes operational information from the event, supports local operations and synchronizes relevant information with Eventify Cloud."
                technology "Edge Computing Service"
                tags "Edge"
            }


            // =====================================================
            // REGISTRATION AND CHECK-IN
            // =====================================================

            attendeeApp = container "Event Registration Mobile App" {
                description "Mobile application used by registered people to access their event information and present the QR code required for check-in."
                technology "Mobile Application"
                tags "Application"
            }

            checkInApp = container "Event Check-In Mobile App" {
                description "Application used at event control stations to validate attendee QR codes, confirm attendance and activate and assign RFID bands."
                technology "Mobile Application"
                tags "Application"
            }


            // =====================================================
            // EVENT ORGANIZER
            // =====================================================

            organizerPlatform = container "Event Organizer Platform" {
                description "Allows Event Organizers to configure event information, upload registered people and review event analytics."
                technology "Web Application"
                tags "Application"
            }


            // =====================================================
            // FOOD PARTNER PLATFORM
            // =====================================================

            foodPartnerWeb = container "Food Partner Web Application" {
                description "Allows Food Partner users to review product and ingredient inventory for Food Dispensers and Coffee Makers deployed at events."
                technology "Web Application"
                tags "Application"
            }

            foodPartnerMobile = container "Food Partner Mobile Application" {
                description "Mobile application for Food Partner users to monitor inventories and keep Food Dispensers and Coffee Makers supplied and operational."
                technology "Mobile Application"
                tags "Application"
            }


            // =====================================================
            // MAINTENANCE PARTNER PLATFORM
            // =====================================================

            maintenanceWeb = container "Device Maintenance Partner Web Application" {
                description "Web application used by maintenance partner office staff to review real-time status information for devices deployed at assigned events."
                technology "Web Application"
                tags "Application"
            }

            maintenanceMobile = container "Technical Support Mobile Application" {
                description "Mobile application used by technical support agents to review device status and perform preventive and corrective maintenance."
                technology "Mobile Application"
                tags "Application"
            }


            // =====================================================
            // CLOUD
            // =====================================================

            cloudBackend = container "Eventify Cloud Backend Services" {
                description "Centralized Cloud services that manage events, registrations, RFID assignments, inventory information, device status, partner information and event analytics across Eventify events."
                technology "Cloud Backend Services"
                tags "Cloud"
            }

            cloudDataStore = container "Eventify Cloud Data Store" {
                description "Stores centralized event, registration, attendee, RFID, inventory, device status and analytics information."
                technology "Cloud Data Store"
                tags "Database"
            }


            // =====================================================
            // REST APIs
            // =====================================================

            foodPartnerApi = container "Food Partner REST API" {
                description "RESTful API that allows Food Partner internal systems to integrate inventory and supply information with Eventify."
                technology "RESTful API"
                tags "API"
            }

            maintenanceApi = container "Maintenance Partner REST API" {
                description "RESTful API that allows maintenance partner internal systems to integrate device status and maintenance information with Eventify."
                technology "RESTful API"
                tags "API"
            }
        }


        // =========================================================
        // USER RELATIONSHIPS
        // =========================================================

        attendee -> eventify.attendeeApp "Uses"

        checkInStaff -> eventify.checkInApp "Uses"

        organizer -> eventify.organizerPlatform "Uses"

        foodPartnerUser -> eventify.foodPartnerWeb "Uses"

        foodPartnerUser -> eventify.foodPartnerMobile "Uses"

        maintenanceAgent -> eventify.maintenanceMobile "Uses"

        maintenanceOffice -> eventify.maintenanceWeb "Uses"


        // =========================================================
        // DEVICE → EDGE
        // =========================================================

        eventify.foodDispenserFirmware -> eventify.edgeService "Sends temperature, stock and RFID consumption events" "Event Wi-Fi"

        eventify.edgeService -> eventify.foodDispenserFirmware "Sends configuration updates" "Event Wi-Fi"

        eventify.coffeeMakerFirmware -> eventify.edgeService "Sends temperature, ingredient stock and RFID consumption events" "Event Wi-Fi"

        eventify.edgeService -> eventify.coffeeMakerFirmware "Sends configuration updates" "Event Wi-Fi"


        // =========================================================
        // CHECK-IN → EDGE
        // =========================================================

        eventify.checkInApp -> eventify.edgeService "Validates check-in operations and registers RFID band activation and assignment" "Event Wi-Fi"


        // =========================================================
        // EDGE → CLOUD
        // =========================================================

        eventify.edgeService -> eventify.cloudBackend "Synchronizes relevant event information" "Internet"

        eventify.cloudBackend -> eventify.edgeService "Synchronizes event configuration and centralized information" "Internet"


        // =========================================================
        // ATTENDEE APPLICATION
        // =========================================================

        eventify.attendeeApp -> eventify.cloudBackend "Retrieves registration information and event QR code" "Internet"


        // =========================================================
        // ORGANIZER
        // =========================================================

        eventify.organizerPlatform -> eventify.cloudBackend "Configures events, uploads registered people and reviews analytics" "Internet"


        // =========================================================
        // FOOD PARTNER APPLICATIONS
        // =========================================================

        eventify.foodPartnerWeb -> eventify.cloudBackend "Reviews inventory and supply information" "Internet"

        eventify.foodPartnerMobile -> eventify.cloudBackend "Reviews inventory and supply information" "Internet"


        // =========================================================
        // MAINTENANCE APPLICATIONS
        // =========================================================

        eventify.maintenanceWeb -> eventify.cloudBackend "Reviews device status and maintenance information" "Internet"

        eventify.maintenanceMobile -> eventify.cloudBackend "Reviews real-time device status and maintenance information" "Internet"


        // =========================================================
        // CLOUD DATA
        // =========================================================

        eventify.cloudBackend -> eventify.cloudDataStore "Stores and retrieves centralized Eventify information"


        // =========================================================
        // FOOD PARTNER API
        // =========================================================

        foodPartnerSystem -> eventify.foodPartnerApi "Integrates inventory and supply information" "REST"

        eventify.foodPartnerApi -> eventify.cloudBackend "Reads and updates Food Partner information"


        // =========================================================
        // MAINTENANCE PARTNER API
        // =========================================================

        maintenancePartnerSystem -> eventify.maintenanceApi "Integrates maintenance and device information" "REST"

        eventify.maintenanceApi -> eventify.cloudBackend "Reads and updates maintenance information"
    }


    // =============================================================
    // VIEWS
    // =============================================================

    views {

        container eventify "EventifyContainerDiagram" {

            include *

            autolayout lr
        }


        // =========================================================
        // STYLES
        // =========================================================

        styles {

            element "Element" {
                shape roundedbox
            }

            element "Person" {
                shape person
            }

            element "Firmware" {
                background #4CAF50
                color #ffffff
                stroke #388E3C
            }

            element "Edge" {
                background #FF9800
                color #ffffff
                stroke #F57C00
            }

            element "Application" {
                background #9C27B0
                color #ffffff
                stroke #7B1FA2
            }

            element "Cloud" {
                background #2196F3
                color #ffffff
                stroke #1976D2
            }

            element "API" {
                background #00ACC1
                color #ffffff
                stroke #00838F
            }

            element "Database" {
                shape cylinder
                background #3F51B5
                color #ffffff
                stroke #303F9F
            }

            relationship "Relationship" {
                thickness 2
            }
        }
    }

    configuration {
        scope softwaresystem
    }
}