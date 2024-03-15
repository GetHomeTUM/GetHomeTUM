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
     -  in _#review_ auf Slack kurze Nachricht:
          1) GH-XX:
          2) Link zur GitHub Pull Request
          3) Link zum Jira Ticket
          4) Reviewer markieren
     - Jira Ticket auf _Waiting for Review_

3) **Review:**
     - Falls alles passt:
          1) PR auf GitHub mergen
          2) Jira Ticket in _Done_ verschieben
          3) in _#review_ auf Slack entsprechendes Feedback geben (zB. reacten, in Thread schreiben ist gemerged)
     
     - Falls Überarbeitung nötig:
          1) Inhaltlichen Kommentar in die Conversation der Pull Request auf GitHub schreiben, Betroffenen markieren
          2) Jira Ticket in _In Progress_ verschieben
          3) in _#review_ auf Slack entsprechendes Feedback geben (zB. Kommentar in PR geschrieben, bitte nochmal drüberschauen)

<br/><br/>
## Conventions
**Dateinamen:** snake_case_nicht_camel_case
