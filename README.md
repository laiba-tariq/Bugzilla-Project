## Bug Tracking System README
## Table of Contents

    Introduction
    Roles and Responsibilities
        Manager
        Developer
        QA (Quality Assurance)
    Key Features
    System Requirements
    Getting Started
    Usage
    Contributing
    License

## Introduction

The Bug Tracking System (BTS) is a web-based application facilitating efficient software development project management and bug tracking. It empowers teams to create, manage, and resolve bugs, assign tasks to developers, and monitor project progress. The system encompasses user and project management functionalities.
Roles and Responsibilities
Manager

    Create a Project: Managers initiate new software development projects.
    Edit and Delete Projects: Managers have the authority to modify project details and delete projects they've created.
    Add/Remove Developers and QAs: Managers can manage project teams by adding or removing developers and quality assurance personnel.

## Developer

    Assign Bugs: Developers can assign bugs to themselves for resolution.
    View Assigned Projects: Developers access the list of projects they're assigned to and work on bugs within those projects.
    Mark Bugs as Resolved: Developers have the capability to mark bugs as resolved once fixed.
    Limited Project Access: Developers can only interact with projects they're assigned to, without project creation/editing privileges.

 ## QA (Quality Assurance)

    Report Bugs: QAs can report bugs for all projects.
    View All Projects: QAs have access to view all projects and monitor bug reports.
    Limited Project Management: QAs cannot create, edit, or delete projects but can contribute to the QA process across multiple projects.

## Key Features

    User Authentication: Users can sign up, log in, and log out using their credentials.
    Project Management: Managers can create, edit, and delete projects, and manage project teams.
    Bug Tracking: Users can report bugs, assign them to developers, and mark bugs as resolved.
    Project-Related Actions: Developers can work on bugs within assigned projects, while QAs can report bugs across all associated projects.
    Bug Details: Bugs include descriptive titles, deadlines, screenshots (in .png or .gif format), types (feature or bug), and statuses.
## System Requirements

To set up the project, create a `.env` file with the following details:

- **db_path:** Set to the file path where your SQLite database will be stored.

For example:

```env
db_path=./db/bug_tracking_system.db
For an enhanced user experience, the root page is set to Home#index.
Getting Started

To create the project, follow the instructions in the README. Set up the .env file with the necessary database connection details.
Usage

Users can log in to view their projects. Managers have additional privileges to create projects, manage project teams, and more. Developers can assign bugs, and QAs can report bugs.
Contributing

No specific information provided.
License

No license information provided.
