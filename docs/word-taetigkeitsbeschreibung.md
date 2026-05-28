# Taetigkeitsbeschreibung (Word-Vorlage)

## Projektkontext und Zielbild

Im Rahmen des studentischen Projekts wurde ein funktionsfaehiger Planning-Prototyp aufgebaut, der sich am fachlichen Verhalten der bestehenden AL-Logik orientiert und als Grundlage fuer einen spaeteren produktiven Einsatz in einer Microsoft-Umgebung dient. Ziel war es, eine nachvollziehbare, kundennahe Planungsoberflaeche mit stabiler Rechenlogik, klaren Statusregeln und vorbereitetem Integrationspfad Richtung API/Dataverse zu realisieren.

## Umgesetzte Taetigkeiten

Zu Beginn wurden Datenmodell und Planungsstruktur als hierarchischer Baum umgesetzt. Darauf aufbauend wurden die zentralen Bearbeitungsfunktionen in der UI integriert, sodass Planwerte auf unterschiedlichen Ebenen gepflegt und konsistent aggregiert werden koennen. Ein Schwerpunkt lag auf der Roll-up- und Top-down-Logik inklusive Rundungs- und Restwertkorrektur, damit Summenbeziehungen zwischen Eltern- und Kindknoten stabil bleiben.

Zusätzlich wurde der Workflow zur fachlichen Freigabe eingefuehrt. Hierbei wurden Statusuebergaenge (`Draft`, `InReview`, `Approved`) abgesichert und Schreibschutzregeln fuer freigegebene Plaene umgesetzt. Damit konnten zentrale Governance-Anforderungen des Zielprozesses im Prototyp realistisch abgebildet werden.

Im naechsten Schritt wurde der Eingabefluss benutzerfreundlich stabilisiert. Eingaben erfolgen als Entwurf und werden erst mit einem expliziten Commit ueber `Aktualisieren` uebernommen. Damit wurde das Risiko unbeabsichtigter Sofort-Aenderungen reduziert. Gleichzeitig wurden Tastaturnavigation (Enter, Pfeiltasten, Escape), visuelles Feedback zu ungespeicherten Aenderungen und ein Aenderungsprotokoll fuer bessere Nachvollziehbarkeit implementiert.

Parallel wurde eine serverseitige API als Source of Truth aufgebaut. Die API unterstuetzt optimistische Nebenlaeufigkeitskontrolle ueber `ETag`/`If-Match`, Rollenpruefung und Statuswechsel. Zur Stabilisierung in der aktuellen Projektphase wurde die Persistenz von reinem In-Memory-Verhalten auf dateibasierte Speicherung umgestellt, sodass Daten auch nach Serverneustarts erhalten bleiben. Dadurch ist der Prototyp fuer Demos und technische Abnahmen deutlich robuster.

## Technische Entscheidungen und Begruendung

Die Rechenlogik wurde bewusst im Frontend gehalten, um fachliche Iterationen schnell sichtbar und testbar zu machen. Fuer Integrations- und Deployment-Reife wurde parallel eine API-Schicht vorbereitet, die spaeter als Bruecke zu Dataverse/OData dient. Dieses Vorgehen verbindet schnelle Produktentwicklung mit einem realistischen Migrationspfad in Richtung produktiver Architektur.

Die Wahl von `ETag`/`If-Match` wurde getroffen, um parallele Bearbeitungen kontrolliert behandeln zu koennen. Konflikte werden erkannt und koennen dem Nutzer transparent angezeigt werden. Der Draft-first-Ansatz mit eindeutigem Commit-Punkt reduziert Inkonsistenzen und passt gut zu kundenorientierten Planungsprozessen, in denen Aenderungen bewusst bestaetigt werden sollen.

## Qualitaetssicherung und Ergebnisstand

Die fachliche Logik wurde durch Unit-Tests (u. a. Roll-up, Verteilung, Statusregeln, Exportschutz) abgesichert. Darueber hinaus wurde ein E2E-Grundgeruest aufgebaut, um Kernflows automatisiert zu pruefen. CI-Bausteine fuer Lint, Tests und Build wurden integriert, sodass der aktuelle Stand reproduzierbar validierbar ist.

Insgesamt ist ein belastbarer Prototyp entstanden, der fuer Meetings und Kundendemonstrationen geeignet ist und die Kernanforderungen der Meilensteine M1 bis M5 weitgehend abdeckt. M6 und M7 sind in zentralen Teilen vorbereitet, wobei die produktive Dataverse-Integration und der vollstaendige Betriebslayer als naechste Umsetzungsschritte verbleiben.

## Naechste Schritte bis Microsoft/Dataverse-Integration

Als naechste technische Etappe werden Dataverse-Mapping und OData-Read/Write finalisiert, Azure AD produktiv konfiguriert und Konflikt-/Monitoringkonzepte in der Zielumgebung abgeschlossen. Danach kann der Prototyp in einen produktionsnahen Deploy- und Betriebsmodus ueberfuehrt werden.
