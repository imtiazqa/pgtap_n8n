# 🧪 PostgreSQL Test Automation with pgTAP + n8n

This project automates database testing using **pgTAP** and **n8n**, allowing you to validate schema, functions, triggers, and stored procedures in PostgreSQL using a no-code workflow.

---

## 🔧 Prerequisites

- Docker
- Basic knowledge of SQL and PostgreSQL
- [n8n](https://n8n.io/) installed via Docker

---

## 🚀 Quick Setup

### 1. Start n8n with Docker

```bash
apk update && apk add docker-cli

docker run -it --name n8n -u 0 \
  -p 5678:5678 \
  -v ${HOME}/.n8n:/home/node/.n8n \
  -v /var/run/docker.sock:/var/run/docker.sock \
  n8nio/n8n

**📂 Files Included**

| File                      | Description                      |
| ------------------------- | -------------------------------- |
| `pgTAP Test Agent.json`   | n8n workflow file to be imported |
| `ddl_dml_tests.sql`       | Sample pgTAP SQL test file       |


**📥 Import the Workflow**
1.	Open n8n in the browser
2.	Click Import and upload pgTAP Test Agent.json
3.	Save the workflow

**🔁 Workflow Steps (Inside n8n)**
3.1 Manual Trigger – Start the workflow manually
3.2 Start PostgreSQL – Run PostgreSQL 17 container
3.3 Add SQL File – Copy ddl_dml_tests.sql to container
3.4 Install pgTAP – Install pgTAP inside the container
3.5 Run Tests – Execute pgTAP tests via pg_prove
3.6 Fetch Results – Read test output from container
3.7 Format Results – Clean and decorate the output

**📸 Workflow Screenshot**

<img width="1627" height="297" alt="image" src="https://github.com/user-attachments/assets/22b5872d-ea0d-4c89-b8fd-c0e910124478" />

**📄 Sample Output**

/tmp/ddl_dml_tests.sql ..
1..10
✅ ok 1 - Department table created
✅ ok 2 - 1 row inserted
✅ ok 3 - Row updated
✅ ok 4 - Row deleted
...
🏁 Result: ✅ PASS


**✅ Summary**
This setup lets you test PostgreSQL schemas and logic automatically inside Docker using pgTAP and n8n — without a full CI/CD pipeline.

