workspace "AirWatch IoT Solution" "Container Diagram for AirWatch" {

    !identifiers hierarchical

    model {

        // =========================
        // USERS
        // =========================

        facilityManager = person "Facility Manager" {
            description "Monitors air quality and building conditions."
        }

        safetyStaff = person "Safety / Health Staff" {
            description "Reviews alerts, air quality conditions and recommendations."
        }

        auditor = person "Auditor" {
            description "Reviews environmental information and reports."
        }


        // =========================
        // EXTERNAL SYSTEMS
        // =========================

        identityService = softwareSystem "CleanAir Identity and Access Control" {
            description "External service for authentication and access control."
        }

        iotConnect = softwareSystem "CleanAir Systems IoT Connect" {
            description "External IoT monitoring service that centralizes device and air quality information."
        }


        // =========================
        // AIRWATCH SYSTEM
        // =========================

        airWatch = softwareSystem "AirWatch Building Air Quality Management" {

            description "IoT solution for indoor air quality monitoring."


            // =====================
            // DEVICE
            // =====================

            monitorFirmware = container "AIAMU Firmware" {
                description "Embedded software running on the ESP32. Reads temperature, CO2 and PM2.5 sensors, updates the LCD and controls status and alert LEDs."
                technology "ESP32 / C++"
                tags "Edge"
            }


            // =====================
            // BUILDING EDGE
            // =====================

            buildingEdge = container "Building Edge Gateway Service" {
                description "Receives /air-readings from AIAMU devices, validates zone thresholds and returns alertLedState."
                technology "Edge Service"
                tags "Edge"
            }


            // =====================
            // CLOUD ENTRY POINTS
            // =====================

            edgeApiGateway = container "Edge Services API Gateway" {
                description "Receives requests coming from Building Edge Gateways."
                technology "API Gateway"
                tags "API"
            }

            clientApiGateway = container "Client Applications API Gateway" {
                description "Receives requests from AirWatch web and mobile applications."
                technology "API Gateway"
                tags "API"
            }


            // =====================
            // CLOUD SERVICES
            // =====================

            domainServices = container "Air Quality Domain Microservices" {
                description "Python FastAPI microservices, one per bounded context, for air quality management, monitoring and platform operations."
                technology "Python / FastAPI"
                tags "Cloud"
            }


            // =====================
            // DATA
            // =====================

            relationalDb = container "PostgreSQL Databases" {
                description "Relational databases owned by the corresponding domain microservices."
                technology "PostgreSQL"
                tags "Database"
            }

            telemetryDb = container "Air Quality Time-Series Database" {
                description "Stores historical air quality telemetry."
                technology "InfluxDB"
                tags "Database"
            }


            // =====================
            // APPLICATIONS
            // =====================

            webApp = container "AirWatch Management Web App" {
                description "Web application for facilities management and occupational health staff."
                technology "React / TypeScript"
                tags "Application"
            }

            mobileApp = container "AirWatch BuildingApp" {
                description "Mobile application for monitoring air quality, receiving alerts and reviewing recommendations."
                technology "Mobile Application"
                tags "Application"
            }
        }


        // =========================
        // DEVICE AND EDGE
        // =========================

        airWatch.monitorFirmware -> airWatch.buildingEdge "Sends temperature, CO2 and PM2.5 readings" "REST /air-readings"

        airWatch.buildingEdge -> airWatch.monitorFirmware "Returns alertLedState" "REST response"


        // =========================
        // EDGE TO CLOUD
        // =========================

        airWatch.buildingEdge -> airWatch.edgeApiGateway "Sends relevant building information" "Internet / REST"

        airWatch.edgeApiGateway -> iotConnect "Sends IoT information" "REST"


        // =========================
        // CLOUD
        // =========================

        airWatch.domainServices -> iotConnect "Queries IoT monitoring information" "REST"

        airWatch.domainServices -> airWatch.relationalDb "Stores and reads relational information"

        airWatch.domainServices -> airWatch.telemetryDb "Stores and reads air quality telemetry"


        // =========================
        // APPLICATIONS
        // =========================

        facilityManager -> airWatch.webApp "Uses"

        safetyStaff -> airWatch.webApp "Uses"

        safetyStaff -> airWatch.mobileApp "Uses"

        auditor -> airWatch.mobileApp "Uses"

        airWatch.webApp -> airWatch.clientApiGateway "Sends requests" "HTTPS"

        airWatch.mobileApp -> airWatch.clientApiGateway "Sends requests" "HTTPS"

        airWatch.clientApiGateway -> airWatch.domainServices "Routes application requests"


        // =========================
        // IDENTITY
        // =========================

        airWatch.clientApiGateway -> identityService "Validates identity and access" "REST"
    }


    views {

        container airWatch "AirWatchContainerDiagram" {

            include *

            autolayout lr
        }

        styles {

            element "Person" {
                shape person
            }

            element "Edge" {
                background #FF9800
                color #ffffff
            }

            element "API" {
                background #00ACC1
                color #ffffff
            }

            element "Cloud" {
                background #2196F3
                color #ffffff
            }

            element "Application" {
                background #9C27B0
                color #ffffff
            }

            element "Database" {
                shape cylinder
                background #3F51B5
                color #ffffff
            }
        }
    }

    configuration {
        scope softwaresystem
    }
}