workspace {

    model {
        !identifiers hierarchical
        properties {
            "structurizr.groupSeparator" "/"
        }

        pseudoniemenService = softwareSystem "Pseudoniemen Service" {
            tags "GF"
        }
        adressering = softwareSystem "Adressering" {
            tags "GF"
        }
        nvi = softwareSystem "Nationale Verwijs Index" {
            tags "GF"
        }

        group "Andere zorgaanbieder" {
            bronLmr = softwareSystem "Lokalisatie Metadata Register (bron)" {
                tags "Bron ontsluiting"
            }
        }

        group "Zorgverlener domein" {
            lmr = softwareSystem "Lokalisatie Metadata Register" {
                tags "Bron ontsluiting"

                api = container "API"
                db = container "Database"
            }
            lrs = softwareSystem "Lokalisatie Register Service" {
                tags "Zorgtoepassing"
                api = container "LRS API"
            }
            lmrBevrager = person "Bevrager"
            epd = softwareSystem "EPD/PACS" {
                tags "Zorgtoepassing"
                tijdlijnModule = container "Tijdlijn module"
            }
        }
        lmr -> nvi "Registreer dossier"
        lmrBevrager -> epd "Maak tijdlijn"
        epd.tijdlijnModule -> lrs.api "Haal gegevens op"
        lrs.api -> pseudoniemenService "Maak pseudoniem"
        lrs.api -> nvi "Lokaliseer"
        lrs.api -> adressering "Zoek endpoints"
        lrs.api -> lmr "Sla metadata op"
        lrs.api -> bronLmr "Haal metadata op"
    }

    views {
        terminology {
            person "Persoon"
            softwareSystem "Systeem"
            container "Container"
            component "Component"
            deploymentNode "Deployment node"
            infrastructureNode "Infrastructuur"
            relationship "Relatie"
        }

        systemContext lrs "LMR" {
            include *
        }

        dynamic * "Lokaliseren-LRS" {
            title "Lokaliseren met LRS"
            epd -> lrs "Haal gegevens op (BSN als input)"
            lrs -> pseudoniemenService "Maak pseudoniem voor NVI"
            lrs -> nvi "Lokaliseer"
            lrs -> adressering "Haal endpoints op"
            lrs -> pseudoniemenService "Maak pseudoniemen voor LMRs" 
            lrs -> bronLmr "Haal metadata op" 
            autoLayout
        }

        dynamic * "Metadata-registratie" {
            title "Metadata registreren bij LMR"
            epd -> lrs "Registreer metadata"
            lrs -> pseudoniemenService "Maak pseudoniem voor LMR"
            lrs -> lmr "Registreer metadata"
            lrs -> pseudoniemenService "Maak pseudoniem voor NVI"
            lmr -> nvi "Registreer dossier beschikbaarheid"
            autoLayout
        }

        styles {
            element Element {
                stroke "#000000"

                properties {
                    plantuml.shadow true
                }
            }
            element "Zorgtoepassing" {
                background "#c5c5c5"
                color "#000000"
            }

            element "GF" {
                background "#ecc22e"
                color "#000000"
            }

            element "Bronsystemen" {
                background "#c5c5c5"
                color "#000000"
            }

            element "Bron ontsluiting" {
                background "#9c9c9c"
                color "#000000"
            }
            
        }
    }
}