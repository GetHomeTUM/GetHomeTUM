# gethome

## Conventions
Dokumentation der TODOs:
>// TODO [Thema/Aufgabe]: Kommentar

<br/><br/>
## Coding Workflow
Aufgabenübersicht -> Jira Kanban Board: [https://gethome.atlassian.net/jira/software/projects/GH/boards/1](https://gethome.atlassian.net/jira/software/projects/GH/boards/1)

Folgender Workflow, nachdem man sich entschieden hat oder besprochen wurde, eine **Aufgabe zu übernehmen**:
1) Ticket in _In Progress_ verschieben

2) Git Branch erstellen: **GH-XX_NameDerAufgabe**

3) Inhaltliche Changes mit Kommentar zu diesem Aufgabenbranch committen und pushen

4) Aufgabe abgeschlossen (Schnittstellen bereitgestellt & Sicherheit(Exceptions, Error Handling, edge cases etc.)):                               
     -> **Pull Request** auf GitHub erstellen, Aufgabenbranch -> main. Detaillierte Beschreibung mit Link zu Jira Ticket

5) Ticket in _Waiting for Review_ verschieben und berichten (zB. Kurzer Kommentar auf Slack)

6) Nach Erfolgreichem Review kann der Reviewer die Pull Request approven und Ticket in _Done_ verschieben
