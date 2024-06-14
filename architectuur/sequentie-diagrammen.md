# Algemeen
## Setup Saas_aanbieder in BSNk stelsel

```mermaid
sequenceDiagram
autonumber
Zorgaanbieder ->> Saas_aanbieder: verwerkersovereenkomst
Saas_aanbieder ->> BSNk: aanmelden
BSNk ->> BSNk: valideer leverancier
BSNk ->> Saas_aanbieder: BSNk_namespace + OIN + sleutelmateriaal
Saas_aanbieder ->> Saas_aanbieder: start zelf BSNk instantantie in HSM
Saas_aanbieder ->> BSNk: aanmelden klanten (zorgaanbieders) bij BSNk
BSNk ->> Saas_aanbieder: sleeutelmateriaal per klant (zorgaanbieder)
```
### openstaande vragen": Hoe zet ZA URA om naar OIN/ hoe verkrijgt ZA OIN, Hoe kan saas_aanbieder gemachtigd worden (vragen aan BSNk en CIBG)?

## Opvragen DEP's op basis BSN’s van ingeschreven patienten (door raadplegers en bronhouders)
Voor de meest voorkomende partijen DEPs opvragen zodat die direct beschikbaar zijn in een interactie met het LokalisatieRegister (LR), ToestemmingsVoorziening (TV).

Aanvragen DEP’s voor zelf (ZA1): Om tot het eigen Pseudoniem (PS) te komen moet er eerst een DEP@ZA1 opgevraagd worden en vervolgens worden ge-decrypt met eigen sleutelmateriaal.

```mermaid
sequenceDiagram
autonumber
loop foreach BSN per zorgaanbieder
  Saas_aanbieder ->> BSNk: request DEP(BSN)@[ZA1, LR, TV]
  BSNk ->> BSNk: create & sign each requested DEP
  BSNk ->> BSNk: sign [DEP(BSN)@ZA1, DEP(BSN)@LR, DEP(BSN)@TV]
  BSNk ->> Saas_aanbieder:  return [DEP(BSN)@ZA1, DEP(BSN)@LR, DEP(BSN)@TV]
  Saas_aanbieder ->> Saas_aanbieder:  decrypt DEP(BSN)@ZA1 to PS(BSN)@ZA1 ("PolfmorfPSeudoniem")
  Saas_aanbieder ->> Saas_aanbieder:  Save PS & DEPS to patientindex@ZA1
end
```
# use-case Ia
## Aanmelden BSN:ZA2 in LokalisatieRegister (LR) tbv 'WAAR' vraag
```mermaid
sequenceDiagram
autonumber
loop foreach BSN
  Saas_aanbieder ->> LR: upload DEP(BSN)@LR, ZA2, ZA2-type
  LR ->> LR: decrypt DEP(BSN)@LR to PS(BSN)@LR
  LR ->> LR: save PS(BSN)@LR, ZA2, ZA2-type
end
```

## Aanmelden Metadata voor BSN:ZA2 in MetaDataRegister (MDR) tbv ‘gepersonaliseerde welke’ vraag
```mermaid
sequenceDiagram
autonumber
loop foreach BSN
  Saas_aanbieder ->> MDR: upload metadata DEP(BSN)@LR, ZA2, ZA2-type, MetaData
  MDR ->> MDR: decrypt DEP(BSN)@LR naar PS(BSN)@LR
  MDR ->> MDR: save PS(BSN)@LR, ZA2, ZA2-type, MetaData
end
```

## 'WAAR' vraag stellen aan LokalisatieRegister (LR) op basis toestemming

```mermaid
sequenceDiagram
autonumber
Saas_aanbieder ->> TV: Open Toestemmingsvraag [DEP(BSN)@ZA1, DEP(BSN)@LR, DEP(BSN)@TV], ZA1, ZA1-type
TV ->> TV: decrypt DEP(BSN)@TV to PS(BSN)@TV
TV ->> TV: find toestemmingsantwoord [PS]
TV ->> TV: sign [toestemmingsantwoord (ZAx, ZAy-type), [DEP(BSN)@ZA1, DEP(BSN)@LR, DEP(BSN)@TV]]
TV ->> Saas_aanbieder: return [toestemmingsantwoord (ZAx, ZAy-type), [DEP(BSN)@ZA1, DEP(BSN)@LR, DEP(BSN)@TV]]
Saas_aanbieder ->> LR: Lokalisatievraag [toestemmingsantwoord (ZAx, ZAy-type),[DEP(BSN)@ZA1, DEP(BSN)@LR, DEP(BSN)@TV]], ZA1
LR ->> LR: decrypt DEP(BSN)@LR to PS(BSN)@LR
LR ->> LR: validate toestemmingsantwoord
LR ->> LR: find permitted organisations (zorgaanbieders)
LR ->> Saas_aanbieder: Send lokalisatieantwoord [ZA2. ZA3]
```

# use-case Ib
```mermaid
sequenceDiagram
autonumber
Saas_aanbieder->> BSNk: request DEP [ZA2, ZA3], DEP(BSN)@ZA1
BSNk ->> BSNk: create & sign each requested DEP
BSNk ->> Saas_aanbieder:  return DEP(BSN)@ZA2, DEP(BSN)@ZA3
Saas_aanbieder->>ZA2: query (metadata, DEP(BSN)@ZA2)
ZA2->>ZA2: decrypt DEP(BSN)@ZA2 to PS(BSN)@ZA2
ZA2->>ZA2: find DEP(BSN)@TV in patientindex (PS(BSN)@ZA2)
ZA2->>TV: Gesloten Toestemmingsvraag <br/>[DEP(BSN)@ZA2, DEP(BSN)@LR, DEP(BSN)@TV], ZA1, ZA1-type, ZA2, ZA2-type
TV ->> TV: decrypt DEP(BSN)@TV to PS(BSN)@TV
TV ->> TV: find toestemmingsantwoord [PS]
TV->>ZA2: permit
ZA2->>Saas_aanbieder: response to query
```

# use-case IIa: onderzoeksdata versturen naar onderzoeksinstituut 1 (OI1)
```mermaid
sequenceDiagram
autonumber
Saas_aanbieder->> BSNk: request DEP [OI1], DEP(BSN)@ZA1
BSNk ->> BSNk: create & sign each requested DEP
BSNk ->> Saas_aanbieder:  return (DEP(BSN)@OI1)
Saas_aanbieder->>TV: ZA2->>TV: Gesloten Toestemmingsvraag <br/>[DEP(BSN)@ZA1, DEP(BSN)@TV], ZA1, ZA1-type
Saas_aanbieder->>OI1:  push (data, DEP(BSN)@OI1)
OI1->>OI1: decrypt DEP(BSN)@OI1 to PS(BSN)@OI1
OI1->>OI1: store (data, PS(BSN)@OI1)
```

# use-case IIb: onderzoeksdata versturen naar onderzoeksinstituut 1 (OI1) en vragenlijst naar berichtenbox (BB)
```mermaid
sequenceDiagram
autonumber
Saas_aanbieder->> BSNk: request DEP [OI1, BB1], DEP(BSN)@ZA1
BSNk ->> BSNk: create & sign each requested DEP
BSNk ->> Saas_aanbieder:  return [DEP(BSN)@OI1, DEP(BSN)@BB]
Saas_aanbieder->>TV: ZA2->>TV: Gesloten Toestemmingsvraag <br/>[DEP(BSN)@ZA1, DEP(BSN)@TV], ZA1, ZA1-type
Saas_aanbieder->>OI1:  push (data, [DEP(BSN)@OI1, DEP(BSN)@BB])
OI1->>OI1: decrypt (DEP(BSN)@OI1 to PS(BSN)@OI1)
OI1->>OI1: store (data, PS(BSN)@OI1)
OI1->>BB: send (vragenlijst, [DEP(BSN)@OI1, DEP(BSN)@BB])
BB->>BB: decrypt (DEP(BSN)@BB to PS(BSN)@BB)
BB->>BB: find e-mailadres (PS(BSN)@BB)
BB->>BB: deliver mail
```

# use-case IIc: Onderzoeksinstituut wil op basis ontvangen data aanvullende vragen stellen aan bv Huisarts of apotheek
```mermaid
sequenceDiagram
autonumber
OI1->> BSNk: request DEP [LR, TV, OI1], DEP(BSN)@OI1
BSNk ->> BSNk: create & sign each requested DEP
BSNk ->> Saas_aanbieder:  return [DEP(BSN)@LR, DEP(BSN)@TV, DEP(BSN)@OI1]
OI1->>TV: Open Toestemmingsvraag <br/>[DEP(BSN)@LR, DEP(BSN)@TV, DEP(BSN)@OI1], OI1
TV ->> TV: decrypt DEP(BSN)@TV to PS(BSN)@TV
TV ->> TV: find toestemmingsantwoord [PS]
TV ->> TV: sign [toestemmingsantwoord (OI1), [DEP(BSN)@LR, DEP(BSN)@TV, DEP(BSN)@OI1]]
TV ->> Saas_aanbieder: return [toestemmingsantwoord (OI1), [DEP(BSN)@LR, DEP(BSN)@TV, DEP(BSN)@OI1]]
OI1 ->> LR: Lokalisatievraag [toestemmingsantwoord (OI1), [DEP(BSN)@LR, DEP(BSN)@TV, DEP(BSN)@OI1]], OI1
LR ->> LR: decrypt DEP(BSN)@LR to PS(BSN)@LR
LR ->> LR: validate toestemmingsantwoord
LR ->> LR: find permitted organisations (zorgaanbieders)
LR ->> OI1: Send lokalisatieantwoord [HA1]
OI1 ->>BSNk: vraag DEP voor HA1? Dan ontvangt niet BSN-gerechtigde partij iets dat wel om te zetten is tot BSN....

```
1) lokalisatie Huisarts/apotheek (mag niet-bsn gerechtigde partij OI1 DEPjes aanvragen voor LR?: vraag aan BSNk)
2) Vraag DEP aan voor Huisarts/apotheek (via ZA1 die data aanleverde of mag niet-bvn gerechtigde partij OI1 DEPjes aanvragen voor Huisarts/Apotheek).
3) Query aan Huisarts/apotheek
4) Huisarts/apotheek checked toestemming
5) Huisarts/apotheek levert gegevens aan
