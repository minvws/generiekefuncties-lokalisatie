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
Voor de meest voorkomende partijen DEPs opvragen zodat die direct beschikbaar zijn in een interactie met het LokalisatieRegister, Toestemmingsvoorziening.

Om tot het eigen Pseudobiem (PS) te komen moet er eerst een DEP@ZA1 opgevraagd worden en vervolgens worden ge-decrypt met eigen sleutelmateriaal.

```mermaid
sequenceDiagram
autonumber
loop foreach BSN per zorgaanbieder
  Saas_aanbieder ->> BSNk: aanmelden BSN (@ZA1, @LokalisatieRegister, @ToestemmingsVoorziening)
  BSNk ->> Saas_aanbieder:  DEP(BSN)@ZA1
  BSNk ->> Saas_aanbieder:  DEP(BSN)@LokalisatieRegister
  BSNk ->> Saas_aanbieder:  DEP(BSN)@ToestemmingsVoorziening
  Saas_aanbieder ->> Saas_aanbieder:  decrypt DEP(BSN)@ZA1 =PS(BSN)@ZA1 ("PolfmorfPSeudoniem")
  Saas_aanbieder ->> Saas_aanbieder:  Sla DEP's op
end
```

# Aanmelden BSN:ZA1 in LokalisatieRegister
```mermaid
sequenceDiagram
autonumber
loop foreach BSN
  Saas_aanbieder ->> LokalisatieRegister: Aanmelden DEP(BSN)@LR, ZA1
  LokalisatieRegister ->> LokalisatieRegister: decryptie DEP(BSN)@LR naar PS(BSN)@LR
  LokalisatieRegister ->> LokalisatieRegister: Opslaan PS(BSN)@LR, ZA1
end
```

# Aanmelden Metadata voor BSN:ZA1 in Lokalisatieregister
```mermaid
sequenceDiagram
autonumber
loop foreach BSN
  Saas_aanbieder ->> LokalisatieRegister: Aanmelden metadata \n DEP(BSN)@LR, ZA1, MetaData
  LokalisatieRegister ->> LokalisatieRegister: decryptie DEP(BSN)@LR naar PS(BSN)@LR
  LokalisatieRegister ->> LokalisatieRegister: Opslaan PS(BSN)@LR, ZA1, MetaData
end
```
