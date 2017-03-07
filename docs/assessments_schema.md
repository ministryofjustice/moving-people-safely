# Assessments Schema

Description of the schema for the [assessments file](config/assessments.yml).

The top level of the schema contains the different **type of assessments** available right now:

```yml
assessment:
  risk:
    ...
  healthcare:
    ...
```

Each assessment is split into **sections**:

```yml
...
  sections:
    risk_to_self:
      ...
    risk_from_others:
      ...
```

Each section has two main components, a list of **questions** and an *optional* list of **subsections**:

```yml
...
  sections:
    risk_from_others:
      questions:
        -
          name: acct_status
          ...
        -
          name: csra
          ...
```

```yml
...
  sections:
    violence:
      ...
      subsections:
        discrimination:
          questions:
            -
              name: risk_to_females
```

The subsections have exactly the same structure of a section.

Each question has a set of configuration attributes:

* **name** - the name of the question
* **mandatory** - [true|false] determines if the question is mandatory for the assessment to be considered completed
* **relevant_answers** - list of answers that are considered relevant, normally used to flag alerts on the associated question if answer included in the list
* **details** - list of details that need to be filled in if the answer requires additional details
* **dependencies** - list of other questions that the question depends on if answer is relevant (by convention, if no relevant answers are described, 'yes' and true are considered relevant answers)

```yml
  ...
  risk_to_self:
    questions:
      -
        name: acct_status
        mandatory: true
        relevant_answers:
          - open
          - post_closure
          - closed_in_last_6_months
        details:
          - date_of_most_recently_closed_acct
          - acct_status_details
  ...
  violence:
    questions:
      -
        name: violence_due_to_discrimination
        mandatory: true
        dependencies:
          - risk_to_females
          - homophobic
          - racist
          - other_violence_due_to_discrimination
```
