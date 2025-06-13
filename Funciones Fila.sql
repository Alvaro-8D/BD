-- substrae la cadena desde posición 2, 
-- saca los tres garacteres siguientes (2,3,4)
select substr('círculo', 2, 3) respuesta
from sys.dual;  

select length('círculo') respuesta
from sys.dual;

-- muestra la posición donde se encuentra por primera vez esa cadena
select instr('onouuuno', 'no') respuesta
from sys.dual; 

-- rellena a izquierda(lpad) o derecha(rpad) los huecos
-- con una cadena ('x') hasta llegar a un numero de caracteres (20)
select lpad('alvaro claudio', 20,'x') respuesta, lpad('alvaro', 20,'x') respuesta2
from sys.dual;

select rpad('alvaro claudio ', 20,'x') respuesta, rpad('alvaro ', 20,'x') respuesta2
from sys.dual;

-- remplaza una cadena ('uno') por otra cadena (' XD ')
select replace('onounouuno', 'uno', ' XD ') respuesta
from sys.dual;

-- pone en MAYUSCULA(upper), minuscula(lower) o Capitaliza(initcap) una cadena
select upper('monDONGo') respuesta
from sys.dual;

select lower('monDONGo') respuesta
from sys.dual;

select initcap('monDONGo') respuesta
from sys.dual;

-- preguntar duda a antonio : trim,ltrim,rtrim
select ltrim('hola que tal hola pablo hola', 'hol') respuesta
from sys.dual;

select rtrim('hola que tal hola pablo hola', 'hol') respuesta
from sys.dual;

-- preguntar duda a antonio : char(x)
select 'num: '||char(0) respuesta
from sys.dual;

-- redonde a ese decimal (si es negativo redondea unidades decenas , etc)
select round(4163/7, 2) respuesta
from sys.dual;

-- trunca a ese decimal (si es negativo trunca unidades decenas , etc)
select trunc(4163/7, 2) respuesta
from sys.dual;

-- devuelve el resto de la division
select mod(4162,2) respuesta
from sys.dual;

-- devuelve el valor absoluto
select abs(-31) respuesta
from sys.dual;

-- redondea hacia arriba siempre
select ceil(44.1) respuesta
from sys.dual;

-- redondea hacia abajo siempre (igual que truncar)
select floor(44.9) respuesta
from sys.dual;

-- eleva 2 a (8) veces
select power(2,8) respuesta
from sys.dual;

-- Fechas -----------------------------------------------
declare
v1 date := '05-03-2024';
begin
dbms_output.put_line('to_char = '||to_char(v1,'hh:mi:ss"  "dd"/"mm"/"yyyy'));
dbms_output.put_line('to_char = '||to_char(1234.5678, '0009999.99'));
dbms_output.put_line('+num/24 = '||to_char(v1+2/24,'hh:mi:ss"  "dd"/"mm"/"yyyy'));

dbms_output.put_line('months_between = '||months_between(sysdate,v1));

dbms_output.put_line('add_month = '||to_char(add_months(v1,3),'hh:mi:ss"  "dd"/"mm"/"yyyy'));

dbms_output.put_line('next_day = '||to_char(next_day(v1,'lunes'),'hh:mi:ss"  "dd"/"mm"/"yyyy'));

dbms_output.put_line('last_day = '||to_char(last_day(v1),'hh:mi:ss"  "dd"/"mm"/"yyyy'));

dbms_output.put_line('round = '||round(v1+15,'mm'));

dbms_output.put_line('trunc = '||trunc(v1,'mm'));

dbms_output.put_line('extract = '||extract(year from v1));

dbms_output.put_line('to_date = '||to_char(to_date('08/02/2006', 'dd"/"mm"/"yyyy')+8,'hh:mi:ss"  "dd"/"mm"/"yyyy'));

dbms_output.put_line('to_number = '||to_number(to_char(v1, 'YYYYMMDD')));
end;

-- *************************
savepoint p1;

select * from temple3;

delete temple3;

rollback to p1;

commit;
-- *************************
-- *************************
create table t4 as (select * from temple3);

delete t4;

insert into t4 (numem,numde) values (06,66);

describe t4;

alter table t4
add (constraint numem_pk_t4 primary key (numem));

alter table t4
MODIFY(numem number(4),fecna date default to_date('01-01-2024','dd-mm-yyyy'));

select * from t4;

update t4
set numde = (select numde from t4) + 6, salar = 2
where numem = 6;
-- *************************
-- *************************
create or replace view dept20
as (select empno "Numero Empleado", deptno "Numero Departamento" 
from emp where deptno = 20) with read only

select * from dept20;
-- *************************
-- *************************
declare
v1 emp.empno%type;
v2 emp.sal%type;
v3 emp.job%type;
begin
v1 := 7369;
select empno,sal into v1,v2 from emp 
where empno = v1;
dbms_output.put_line('Cod: '||v1); 

if(v2 > 1200) then
update emp 
set sal = sal*1.2
where empno = v1; 

elsif(v2 = 800) then
dbms_output.put_line('Que PRO!'); 

else
update emp 
set sal = sal*1.25
where empno = v1;

end if;
select sal into v2 from emp 
where empno = v1;
dbms_output.put_line('Sal: '||v2); 
end;
-- *************************
-- *************************
create or replace procedure k2
(v1 in emp.sal%type)
is
begin
dbms_output.put_line('Numero: '||v1);
end k2;


execute k2(20);
-- *************************
-- *************************
declare
v1 number(10);
begin
v1 := 1;
loop
    dbms_output.put_line('loop -> '||v1);
    v1 := v1 + 1;
exit when v1 > 10; end loop;

while (v1 > 1) loop
    dbms_output.put_line('while -> '||v1);
    v1 := v1 - 1;
end loop;

for i in reverse 5..15 loop
    v1 := i;
    dbms_output.put_line('for -> '||v1);
end loop;
end;
-- *************************
-- *************************
declare
cursor c1 is (select nomem from temple3 where numde = &Departamento);
v1 temple3.nomem%type;
begin
open c1;
loop
    fetch c1 into v1;
    exit when (c1%notfound);
    dbms_output.put_line(v1);
end loop;
close c1;
for i in c1 loop
    dbms_output.put_line(i.numem);
end loop;
end;
-- *************************
-- *************************
declare
cursor c1 (p1 temple3.numhi%type) is (select numem,numhi from temple3 where numhi = p1);
v1 temple3.numem%type;
begin
for i in c1(1) loop
    dbms_output.put_line(i.numem||' numhi:'||i.numhi);
end loop;
end;
-- *************************
-- *************************
declare
cursor c1 is (select numem,numhi from temple3);
type re1 is record (numem temple3.numem%type,numhi temple3.numhi%type);
f1 re1;
f2 c1%rowtype;
begin
open c1;
fetch c1 into f1;
fetch c1 into f2;
dbms_output.put_line(f1.numem||' '||f1.numhi);
dbms_output.put_line(f2.numem||' '||f2.numhi);
close c1;
end;
-- *************************
-- ************************* /////////////////////////////////
declare
cursor c1 is (select numem,numhi from temple3);
type re1 is record (numem temple3.numem%type,numhi temple3.numhi%type);
f1 c1%rowtype;
type tipo1 is table of c1%rowtype index by BINARY_INTEGER;
t1 tipo1;
i2 BINARY_INTEGER := 0;
begin    
for i in c1 loop
    f1 := i;
    t1(i2) := f1;
    i2 := i2+1;
end loop;

for i in t1.first..t1.last loop
    dbms_output.put_line(t1(i).numem||' '||t1(i).numhi);  
end loop;
end;
-- *************************
-- *************************
declare
v1 temple3.numem%type;
mecago exception;
begin
select numem into v1 from temple3 where numem = 666;
v1:= 666;
if v1 = 666 then 
raise_application_error(-20001, 'tontito'); 
end if;
if v1 = 110 then raise mecago; end if;
exception
when too_many_rows then 
dbms_output.put_line('eres tonto1');

when dup_val_on_index then 
dbms_output.put_line('eres tonto2');

when zero_divide then 
dbms_output.put_line('eres tonto3');

when no_data_found then 
dbms_output.put_line('eres tonto4');

when mecago then 
dbms_output.put_line('ve al bater');
end;
-- *************************
-- *************************
create or replace procedure k1
is
v1 date := '05-03-2024';
begin
dbms_output.put_line('to_char = '||to_char(v1,'hh:mi:ss"  "dd"/"mm"/"yyyy'));
end k1;

execute k1;
-- *************************
-- *************************
create or replace function z1 (p1 in number)
return number is
begin
return (5/p1);
end z1;

declare
v2 number(10):= 4;
v1 number(10):= z1(v2);
begin
dbms_output.put_line('5/'||v2||'= '||z1(v2));
end;
-- *************************
-- *************************
create or replace package pablo is

    type t_reg is record (numem temple3.numem%type,numhi temple3.numhi%type);
    
    cursor c1 return t_reg;
    
    procedure k1 (p1 in varchar2);
    
    function z1 (p1 in number)return number;

end pablo;

create or replace package body pablo is

    cursor c1 return t_reg is (select numem,numhi from temple3);
    
    procedure k1 (p1 in varchar2) is
    v1 date := '05-03-2024';
    begin
    dbms_output.put_line('to_char = '||to_char(v1,'hh:mi:ss"  "dd"/"mm"/"yyyy'));
    dbms_output.put_line(p1);
    end k1;
    
    function z1 (p1 in number)
    return number is
    begin
    return (5/p1);
    end z1;   
end pablo;

execute pablo.k1('conseguido');

execute pablo.z1(4);
-- *************************