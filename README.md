# gethome
<br/><br/>

> [!IMPORTANT]
> Jira Tickets aktuell halten  (siehe Coding Workflow) -> Transparenz, Übersicht

<br/><br/>
## Coding Workflow
Aufgabenübersicht -> Jira Board: [https://gethome.atlassian.net/jira/software/projects/GH/boards/1](https://gethome.atlassian.net/jira/software/projects/GH/boards/1)

Folgender Workflow, nachdem man sich entschieden hat oder besprochen wurde, eine **Aufgabe zu übernehmen**:

1) **An Ticket arbeiten:**
     - Sich selber assignen und Ticket in _In Progress_ verschieben
     - Git Branch erstellen: **GH-XX_NameDerAufgabe**
     - Passende Commit messages: **GH-XX: Model X überarbeitet, neue Methode getX**

2) **Aufgabe abgeschlossen:**
     -  Check: Schnittstellen, Sicherheit(Exceptions, Error Handling, edge cases etc.), Coventions einhalten
     -  **Pull Request** erstellen, main <- AufgabenBranch (Kurze Beschreibung, Link zu Jira Ticket)
     - Jira Ticket auf _Waiting for Review_
     -  in _#review_ auf Slack kurze Nachricht:
          - GH-XX:
          - Link zur GitHub Pull Request
          - Link zum Jira Ticket
          - Reviewer markieren

3) **Review:**
     - Falls alles passt:
          - PR auf GitHub mergen
          - Jira Ticket in _Done_ verschieben
          - Feedback auf Slack in _#review_ (zB. reacten, in Thread schreiben 'ist gemerged')
     
     - Falls Überarbeitung nötig:
          - Inhaltlichen Kommentar in die Conversation der Pull Request auf GitHub schreiben, Betroffenen markieren
          - Jira Ticket in _In Progress_ verschieben
          - Feedback auf Slack in _#review_ (zB. 'Kommentar in PR geschrieben', 'bitte nochmal drüberschauen')

<br/><br/>
## Conventions
**Dateinamen:** snake_case_nicht_camel_case
