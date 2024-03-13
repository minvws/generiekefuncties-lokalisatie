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

# Aanmelden BSN’s en opzetten naar DEPs
Voor de meest voorkomende partijen DEPs opvragen zodat die direct beschikbaar zijn in een interactie met het LokalisatieRegister (LR), ToestemmingsVoorziening (TV).

Aanvragen DEP’s voor zelf (ZA1): Om tot het eigen Pseudobiem (PS) te komen moet er eerst een DEP@ZA1 opgevraagd worden en vervolgens worden ge-decrypt met eigen sleutelmateriaal.

```mermaid
sequenceDiagram
autonumber
loop foreach BSN per zorgaanbieder
  Saas_aanbieder ->> BSNk: request DEP(BSN)@[ZA1, LR, TV]
  BSNk ->> BSNk: create & sign each requested DEP
  BSNk ->> BSNk: sign [DEP(BSN)@ZA1, DEP(BSN)@LR, DEP(BSN)@TV]
  BSNk ->> Saas_aanbieder:  return [DEP(BSN)@ZA1, DEP(BSN)@LR, DEP(BSN)@TV]
  Saas_aanbieder ->> Saas_aanbieder:  decrypt DEP(BSN)@ZA1 =PS(BSN)@ZA1 ("PolfmorfPSeudoniem")
  Saas_aanbieder ->> Saas_aanbieder:  Save PS & DEPS
end
```

# Aanmelden BSN:ZA1 in LokalisatieRegister tbv 'WAAR' vraag
```mermaid
sequenceDiagram
autonumber
loop foreach BSN
  Saas_aanbieder ->> LokalisatieRegister: upload DEP(BSN)@LR, ZA1
  LokalisatieRegister ->> LokalisatieRegister: decrypt DEP(BSN)@LR naar PS(BSN)@LR
  LokalisatieRegister ->> LokalisatieRegister: save PS(BSN)@LR, ZA1
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

# 'WAAR' vraag stellen aan LokalisatieRegister (LR)

```mermaid
sequenceDiagram
autonumber
Saas_aanbieder ->> ToestemmingsVoorziening: Open Toestemmingsvraag+DEP(BSN)LR+DEP(BSN)@TV, Za1?
ToestemmingsVoorziening ->> Saas_aanbieder: toestemmingsantwoord + DEP(BSN)@TV (signed)
Saas_aanbieder ->> LokalisatieRegister: Lokalisatievraag \n DEP(BSN)@LR, toestemmingsantwoord, ZA1
LokalisatieRegister ->> LokalisatieRegister: decryptie DEP(BSN)@LR naar PS(BSN)@LR
LokalisatieRegister ->> LokalisatieRegister: valideer toestemmingsantwoord
LokalisatieRegister ->> LokalisatieRegister: zoek bijbehorende ZA's waar toestemming voor is
LokalisatieRegister ->> Saas_aanbieder: Stuur antwoord op \n DEP(BSN)@ZA1, LR, ZA's
end
```
