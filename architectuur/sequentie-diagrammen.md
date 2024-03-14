# Setup zorgaanbieder in BSNk stelsel

```mermaid
sequenceDiagram
autonumber
Zorgaanbieder ->> Saas_aanbieder: verwerkersovereenkomst
Saas_aanbieder ->> BSNk: aanmelden
BSNk ->> BSNk: valideer leverancier
BSNk ->> Saas_aanbieder: BSNk_namespace (UZI) + OIN + sleutelmateriaal
Saas_aanbieder ->> Saas_aanbieder: start zelf BSNk instantantie in HSM
Saas_aanbieder ->> Koppeltabel: registreer obv OIN/URA/Zorgaanbieder
```

# Opvragen DEP's op basis BSN’s
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
  Saas_aanbieder ->> Saas_aanbieder:  Save PS & DEPS
end
```

# Aanmelden BSN:ZA1 in LokalisatieRegister (LR) tbv 'WAAR' vraag
```mermaid
sequenceDiagram
autonumber
loop foreach BSN
  Saas_aanbieder ->> LR: upload DEP(BSN)@LR, ZA1
  LR ->> LR: decrypt DEP(BSN)@LR to PS(BSN)@LR
  LR ->> LR: save PS(BSN)@LR, ZA1
end
```

# Aanmelden Metadata voor BSN:ZA1 in MetaDataRegister (MDR) tbv ‘gepersonaliseerde welke’ vraag
```mermaid
sequenceDiagram
autonumber
loop foreach BSN
  Saas_aanbieder ->> MDR: upload metadata \n DEP(BSN)@LR, ZA1, MetaData
  MDR ->> MDR: decrypt DEP(BSN)@LR naar PS(BSN)@LR
  MDR ->> MDR: save PS(BSN)@LR, ZA1, MetaData
end
```

# 'WAAR' vraag stellen aan LokalisatieRegister (LR) op basis toestemming

```mermaid
sequenceDiagram
autonumber
Saas_aanbieder ->> TV: Open Toestemmingsvraag [DEP(BSN)@ZA1, DEP(BSN)@LR, DEP(BSN)@TV], Za1
TV ->> TV: decrypt DEP(BSN)@TV to PS(BSN)@TV
TV ->> TV: find toestemmingsantwoord [PS]
TV ->> TV: sign [toestemmingsantwoord, [DEP(BSN)@ZA1, DEP(BSN)@LR, DEP(BSN)@TV]]
TV ->> Saas_aanbieder: return [toestemmingsantwoord, [DEP(BSN)@ZA1, DEP(BSN)@LR, DEP(BSN)@TV]]
Saas_aanbieder ->> LR: Lokalisatievraag [toestemmingsantwoord,[DEP(BSN)@ZA1, DEP(BSN)@LR, DEP(BSN)@TV]], ZA1
LR ->> LR: decrypt DEP(BSN)@LR to PS(BSN)@LR
LR ->> LR: validate toestemmingsantwoord
LR ->> LR: find permitted organisations (zorgaanbieders)
LR ->> Saas_aanbieder: Send lokalisatieantwoord
```
