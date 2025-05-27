-- EXAMEN BD 3ºEV - EJERCICIO 1
-- Crear tabla RESUMEN
CREATE TABLE RESUMEN (
    FACFNO NUMBER(4) PRIMARY KEY,
    FACNOM VARCHAR2(30),
    SALARIO_MEDIO NUMBER(7,2),
    NUM_PROFESORES NUMBER(3)
);

-- Bloque anónimo PL/SQL
DECLARE
    TYPE t_resumen IS RECORD (
        facfno RESUMEN.FACFNO%TYPE,
        facnom RESUMEN.FACNOM%TYPE,
        salario_medio RESUMEN.SALARIO_MEDIO%TYPE,
        num_profesores RESUMEN.NUM_PROFESORES%TYPE
    );
    
    TYPE t_vector IS TABLE OF t_resumen INDEX BY PLS_INTEGER;
    v_vector t_vector;

    CURSOR c_facultades IS
        SELECT f.facfno, f.facnom
        FROM facultades f;

    v_index PLS_INTEGER := 0;
    v_total_salario NUMBER(10,2);
    v_total_profesores NUMBER(3);
BEGIN
    FOR f IN c_facultades LOOP
        v_total_salario := 0;
        v_total_profesores := 0;
        
        FOR p IN (
            SELECT salario + NVL(bonus, 0) AS total
            FROM profesores
            WHERE facfno = f.facfno
        ) LOOP
            v_total_salario := v_total_salario + p.total;
            v_total_profesores := v_total_profesores + 1;
        END LOOP;
        
        v_index := v_index + 1;
        v_vector(v_index).facfno := f.facfno;
        v_vector(v_index).facnom := f.facnom;
        
        IF v_total_profesores > 0 THEN
            v_vector(v_index).salario_medio := v_total_salario / v_total_profesores;
        ELSE
            v_vector(v_index).salario_medio := 0;
        END IF;
        
        v_vector(v_index).num_profesores := v_total_profesores;
    END LOOP;

    FOR i IN 1..v_index LOOP
        INSERT INTO RESUMEN VALUES (
            v_vector(i).facfno,
            v_vector(i).facnom,
            v_vector(i).salario_medio,
            v_vector(i).num_profesores
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Se ha insertado ' || v_index || ' registros en la tabla RESUMEN.');
END;

-- EXAMEN BD 3ºEV - EJERCICIO 2
-- Procedimiento MOSTRARPUBLICACIONES

CREATE OR REPLACE PROCEDURE MOSTRARPUBLICACIONES(p_numprofesor IN NUMBER) IS
    v_nombre_profesor profesores.nombre%TYPE;
    v_titulo publicaciones.titulo%TYPE;
    v_anio publicaciones.anio%TYPE;
    v_total NUMBER := 0;
    v_indice NUMBER := 0;

    CURSOR c_publicaciones IS
        SELECT titulo, anio
        FROM publicaciones
        WHERE numprofesor = p_numprofesor;

BEGIN
    -- Verificar si existe el profesor
    SELECT nombre INTO v_nombre_profesor
    FROM profesores
    WHERE numprofesor = p_numprofesor;

    DBMS_OUTPUT.PUT_LINE('Nombre del Profesor: ' || v_nombre_profesor);
    DBMS_OUTPUT.PUT_LINE('Publicaciones:');

    OPEN c_publicaciones;
    LOOP
        FETCH c_publicaciones INTO v_titulo, v_anio;
        EXIT WHEN c_publicaciones%NOTFOUND;
        v_total := v_total + 1;
        DBMS_OUTPUT.PUT_LINE('- ' || v_titulo || ' (' || v_anio || ')');
    END LOOP;
    CLOSE c_publicaciones;

    DBMS_OUTPUT.PUT_LINE('Total de Publicaciones: ' || v_total);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Profesor con número ' || p_numprofesor || ' no existe.');
END;

-- PROBAR EJ 2 -----------
BEGIN
    MOSTRARPUBLICACIONES(1001); -- Reemplaza con el número real
END;
-- PROBAR EJ 2 -----------

-- EXAMEN BD 3ºEV - EJERCICIO 3
-- Procedimiento BORRA_PROFESOR

CREATE OR REPLACE PROCEDURE BORRA_PROFESOR(p_numprofesor IN NUMBER) IS
    v_nombre profesores.nombre%TYPE;
    v_total_publicaciones NUMBER := 0;
BEGIN
    -- Verificar si existe el profesor
    SELECT nombre INTO v_nombre
    FROM profesores
    WHERE numprofesor = p_numprofesor;

    -- Contar las publicaciones del profesor
    SELECT COUNT(*) INTO v_total_publicaciones
    FROM publicaciones
    WHERE numprofesor = p_numprofesor;

    -- Borrar publicaciones si las tiene
    DELETE FROM publicaciones
    WHERE numprofesor = p_numprofesor;

    -- Borrar el profesor
    DELETE FROM profesores
    WHERE numprofesor = p_numprofesor;

    -- Mostrar mensaje final
    DBMS_OUTPUT.PUT_LINE('Mensaje: Se ha borrado el profesor/a ' || v_nombre || ' y las ' || v_total_publicaciones || ' publicaciones que tiene.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Profesor con número ' || p_numprofesor || ' no existe.');
END;

-- PROBAR EJ 3 -----------
BEGIN
    BORRA_PROFESOR(1001); -- Sustituye por el número de profesor
END;
-- PROBAR EJ 3 -----------

-- EXAMEN BD 3ºEV - EJERCICIO 4
-- Función MEDIA_SUELDO_BONUS

CREATE OR REPLACE FUNCTION MEDIA_SUELDO_BONUS(p_fecha_ini IN DATE, p_fecha_fin IN DATE)
RETURN NUMBER IS
    v_total NUMBER(10,2) := 0;
    v_count NUMBER := 0;
    v_sueldo_total NUMBER(10,2);
    v_bonus NUMBER(10,2);
    v_media NUMBER(10,2) := 0;
BEGIN
    FOR r IN (
        SELECT salario, NVL(bonus, 0) AS bonus
        FROM profesores
        WHERE fecha_ingreso BETWEEN p_fecha_ini AND p_fecha_fin
    ) LOOP
        v_total := v_total + (r.salario + r.bonus);
        v_count := v_count + 1;
    END LOOP;

    IF v_count > 0 THEN
        v_media := v_total / v_count;
    END IF;

    DBMS_OUTPUT.PUT_LINE('La media de los salarios+bonus de los trabajadores comprendidos entre las fechas ''' ||
                         TO_CHAR(p_fecha_ini, 'DD/MM/YYYY') || ''' y ''' ||
                         TO_CHAR(p_fecha_fin, 'DD/MM/YYYY') || ''' es de ' ||
                         TO_CHAR(v_media, '9G999G999D99') || ' €');
    RETURN v_media;
END;

-- PROBAR EJ 4 -----------
BEGIN
    MEDIA_SUELDO_BONUS(TO_DATE('01/01/2022', 'DD/MM/YYYY'), TO_DATE('31/12/2023', 'DD/MM/YYYY'));
END;
-- PROBAR EJ 4 -----------




