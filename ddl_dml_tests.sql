-- Plan: total number of tests
SELECT plan(10);

-- 1. Create table
CREATE TABLE department (
    dept_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);
SELECT has_table('public', 'department', 'Department table created');


-- 2. Insert
INSERT INTO department (name) VALUES ('HR');
SELECT results_eq('SELECT COUNT(*)::int FROM department', ARRAY[1], '1 row inserted');

-- 3. Update
UPDATE department SET name = 'Finance' WHERE name = 'HR';
SELECT results_eq('SELECT name FROM department WHERE dept_id = 1', ARRAY['Finance'], 'Row updated');

-- 4. Delete
DELETE FROM department WHERE dept_id = 1;
SELECT results_eq('SELECT COUNT(*) FROM department', ARRAY[0]::bigint[], 'Row deleted');

-- 5. Add Primary Key (already added in CREATE, just testing again)
SELECT col_is_pk('public', 'department', 'dept_id', 'dept_id is primary key');

-- 6. Add Foreign Key
CREATE TABLE employee (
    emp_id SERIAL PRIMARY KEY,
    dept_id INT,
    CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);
SELECT col_is_fk('public', 'employee', 'dept_id', 'dept_id is foreign key');

-- 7. Create View
CREATE VIEW v_dept AS SELECT dept_id, name FROM department;
SELECT has_view('public', 'v_dept', 'View v_dept created');

-- 8. Create Function
CREATE OR REPLACE FUNCTION get_dept_count() RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM department);
END;
$$ LANGUAGE plpgsql;
-- ✅ Use correct function signature in text form
--SELECT has_function('public', 'get_dept_count', ARRAY['integer'], 'get_dept_count() function created');
SELECT has_function('public', 'get_dept_count', ARRAY[]::text[], 'get_dept_count() function created');

-- 9. Create Trigger
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    action TEXT,
    changed_at TIMESTAMP DEFAULT now()
);

CREATE OR REPLACE FUNCTION log_insert() RETURNS trigger AS $$
BEGIN
    INSERT INTO audit_log(action) VALUES ('INSERT on department');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_dept_insert
AFTER INSERT ON department
FOR EACH ROW EXECUTE FUNCTION log_insert();

SELECT has_trigger('public', 'department', 'trg_dept_insert', 'Trigger created on department');

-- 10. Create Stored Procedure (PostgreSQL 11+)
CREATE OR REPLACE PROCEDURE truncate_department()
LANGUAGE SQL
AS $$
    TRUNCATE department;
$$;

-- ✅ Correct usage: is_procedure takes argument types as text[]
SELECT is_procedure(
    'public',
    'truncate_department',
    ARRAY[]::text[],
    'truncate_department() exists as a procedure'
);



-- 12. Finish
SELECT * FROM finish();