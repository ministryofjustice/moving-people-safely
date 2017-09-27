# Assessments Schema

Description of the schema for the [assessments file](config/assessments_schema.yml).

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
    security_and_segregation:
      ...
```

## Section

Each section has a list of **questions**

```yml
...
  sections:
    security_and_segregation:
      questions:
        -
          name: acct_status
          ...
        -
          name: csra
          ...
```

## Question

Each **question** has a set of configuration attributes:

* **name** - **[MANDATORY]** the name of the question
* **type** - **[MANDATORY]** [string|boolean|group|complex] defines the type of the question. More details on the different types of question below.
* **validators** - **[OPTIONAL]** list of validators used to ensure the answer provided for the question is valid. More detailed description on the validators format below.
* **questions** - **[CONDITIONAL]** list of children questions. This list is conditional to the types **group** or **complex**, so check their information below in the question types section. Each question here follow the same format as any other question.
* **answers** - **[OPTIONAL]** list of possible answers for the given question

## Validator

Each **validator** has the following structure:

* **name** - **[MANDATORY]** validator class to be used when checking the validaty of the answer
* **options** - **[OPTIONAL]** a set of options to be used by the validator class. Most of them conform with the supported ActiveModel::Validation options (e.g. allow\_blank)

## Answer

Each possible **answer** has the following structure:

* **value** - **[MANDATORY]** the value for the answer
* **relevant** - **[OPTIONAL]** [true|false] (defaults to false). Defines if the answer is relevant or not. If an answer is relevant that will be reflected in the overall assessment summary.
* **questions** - **[OPTIONAL]** a list of options that the answer depends upon. The questions follow the same structure as the **question** structure defined above.

## Question types

* **complex**

If a question is defined as complex it means that the question itself as an object and is considered to be answered by answering all the children questions (attributes) that belong to that question.

```yml
questions:
  -
    name: medications
    type: complex
    questions:
      -
        name: description
        type: string
      -
        name: administration
        type: string
      -
        name: carrier
        type: string
        answers:
          -
            value: 'escort'
          -
            value: 'detainee'
```

* **group**

If a question is defined as **group** it means the question itself doesn't really hold a value, it's considered almost like a virtual attribute. The question contains a group of questions and are those questions that need to be answered.

```yml
questions:
  -
    name: violence_due_to_discrimination_type
    type: group
    validators:
      -
        name: 'Assessments::GroupValidator'
        options:
          at_least: true
    questions:
      -
        name: risk_to_females
        type: boolean
      -
        name: homophobic
        type: boolean
      -
        name: racist
        type: boolean
```

## Examples

Example of a subset of the assessments schema:

```yml
  ...
  arson:
    questions:
      -
        name: arson
        type: string
        validators:
          -
            name: 'Assessments::InclusionValidator'
            options:
              allow_blank: true
        answers:
          -
            value: 'yes'
          -
            value: 'no'
  ...
  harassments:
    sections:
      harassment:
        questions:
          -
            name: harassment
            type: string
            validators:
              -
                name: 'Assessments::InclusionValidator'
                options:
                  allow_blank: true
            answers:
              -
                value: 'yes'
                questions:
                  -
                    name: harassment_details
                    type: string
                    validators:
                      -
                        name: 'Assessments::PresenceValidator'
              -
                value: 'no'
```
