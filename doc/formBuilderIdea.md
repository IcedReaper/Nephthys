Formbuilder Struktur:

{
    typ: "vertical" // vertical | horizontal | 
    name: "registration",
    success: {
        headline: "Vielen Dank",
        message:  "Vielen Dank für Ihre Registrierung. Bitte geben Sie uns etwas Zeit Ihre Anfrage zu bearbeiten."
    },
    fields: [
        [
            {
                label: "Username",
                fieldtype: "input",
                required: true,
                validationType: "userName",
                width: 100%
            }
        ],
        [
            {
                label: "Passwort",
                fieldtype: "password",
                required: true,
                validationType: null,
                width: 100%
            }
        ],
        [
            {
                label: "Email",
                fieldtype: "email",
                required: true,
                validationType: "Email",
                width: 100%
            }
        ]
    ],
    button: [
        {
            left: [
            {
                type: "submit",
                label: "Anmelden",
                Icon: "Signup" // to be translated to font-awesome classes,
                style: "Primary" // to be translated to btn btn-primary, etc
            }],
            right: []
        }
    ]
}

{
    typ: "horizontal" // vertical | horizontal |
    name: "login",
    fields: [
        [
            {
                label: "Username",
                fieldtype: "input",
                required: true,
                validationType: "userName",
                width: 50%
            },
            {
                label: "Passwort",
                fieldtype: "password",
                required: true,
                validationType: null,
                width: 50%
            }
        ]
    ],
    button: [
        {
            left: [
            {
                type: "submit",
                label: "Einloggen",
                Icon: "Signin" // to be translated to font-awesome classes,
                style: "Primary" // to be translated to btn btn-primary, etc
            }],
            right: []
        }
    ]
}