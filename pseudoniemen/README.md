# Introductie

## Pseudonimiseren
Pseudoniemen kunnen worden gebruikt om gegevens, zoals het BSN, om te zetten in een unieke identifier zonder dat deze naar de oorspronkelijke data is terug te leiden.
Dit is handig wanneer data tussen organisaties gecorraleerd moet worden, zonder het BSN te gebruiken.

## Polymorfe pseudoniemen
Polymorfe pseudoniemen worden gebruikt in een stelsel waarin deelenemers sleutelmateriaal krijgen om pseudoniemen te maken speciaal voor andere deelnemers. De pseudoniemen zijn dus deelnemer gebonden. Bij het aanmaken van een pseudoniem is deze versleuteld voor de betreffende deelnemer. Dit zorg er voor dat alleen de "eigenaar" van het pseudoniem dit psuedoniem kent. Het voordeel van deze methode is dat patijen de pseudoniemen niet naast elkaar kunnen leggen. Immers, ieder pseudoniemm is anders.

# Verschijningsvormen en eigenschappen
Een Polymorfe pseudoniem heeft een aantal verschijningsvormen. Deze worden berijkt door een operatie. Hier volgt een omschrijving van deze vormen en hun eigenschappen.

## PIP Polymorf Identiteit Pseudoniem
Dit is de meest generieke vorm. Specifiek voor aanvragende partij. Vaak de authenticatiedienst.

## Ps pseudoniem
Een pseudoniem, niet terug te leiden naar een BSN. Specifiek voor de “relying party”. Persistent, ongeacht de route waar dit Ps vanuit is afgeleid.
## VP Versleuteld pseudoniem
Vversleuteld voor de relying party. Bevat randomisatie, elke keer anders. Kunnen ook datum en stelselversies in. Metadata voor de logistiek.

## VI Versleutelde identiteit
Versleuteld voor de ontvanger, kan terug naar BSN worden vertaald. Bevat randomisatie en metadata, net als de VP.
Diversifier een extra input op de transformeerstap om BSNs te “namespace” (ASN1 string).
Koppelen van de VI en VP door een handtekening.

# Operaties
De verschijningsvormen worden verkregen door het uitvoeren van een aantal cryptografische operaties



