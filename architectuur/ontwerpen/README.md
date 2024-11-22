# Architectuur

## Hulpmiddelen

De architectuur documentatie maakt gebruik van hulpmiddelen voor het maken van
de afbeeldingen en teksten.

### Structurizr

[Structurizr]() wordt gebruikt voor het maken van de verschillende architectuur
diagrammen. Het volgt het [C4 model](). In de `bin` map is een `structurizr`
script wat gebruikt kan worden voor het eenvoudig aanroepen van Structurizrs CLI
tool. Deze maakt gebruik van Docker.

#### Inspect

Voer het volgende commando uit vanuit de architectuur map om feedback te krijgen
de model definitie.

    ./bin/structurizr inspect -w workspace.dsl

#### Afbeeldingen maken

Het `bin/build_images` script maakt alle afbeeldingen op basis van de model definities.
