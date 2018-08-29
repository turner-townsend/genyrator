from enum import Enum
from typing import Optional
import attr
from genyrator.inflector import pythonize


class JoinOption(Enum):
    to_one =  'to_one'
    to_many = 'to_many'


@attr.s
class Relationship(object):
    python_name:                    str =        attr.ib()
    target_entity_class_name:       str =        attr.ib()
    target_entity_python_name:      str =        attr.ib()
    target_foreign_key_column_name: str =        attr.ib()
    source_column_name:             str =        attr.ib()
    property_name:                  str =        attr.ib()
    nullable:                       bool =       attr.ib()
    lazy:                           bool =       attr.ib()
    join:                           JoinOption = attr.ib()


@attr.s
class RelationshipWithoutJoinTable(Relationship):
    target_identifier_column_name: str = attr.ib()


@attr.s
class RelationshipWithJoinTable(Relationship):
    join_table: str = attr.ib()


def create_relationship(
        target_entity_class_name:       str,
        nullable:                       bool,
        lazy:                           bool,
        join:                           JoinOption,
        source_column_name:             Optional[str] = None,
        join_table:                     Optional[str] = None,
        target_identifier_column_name:  Optional[str] = None,
        # our column which stores their primary key
        target_foreign_key_column_name: Optional[str] = None,
        property_name:                  Optional[str] = None,
) -> Relationship:
    target_entity_python_name = pythonize(target_entity_class_name)
    relationship = Relationship(
        python_name=target_entity_python_name,
        target_entity_class_name=target_entity_class_name,
        target_entity_python_name=target_entity_python_name,
        target_foreign_key_column_name=
        target_foreign_key_column_name if target_foreign_key_column_name else f'{target_entity_python_name}_id',
        source_column_name=pythonize(source_column_name),
        property_name=property_name if property_name else target_entity_python_name,
        nullable=nullable,
        lazy=lazy,
        join=join,
    )
    if join_table is None:
        target_identifier_column_name = pythonize(target_identifier_column_name) \
            if target_identifier_column_name else None
        return RelationshipWithoutJoinTable(
            **{**{'target_identifier_column_name': target_identifier_column_name, **relationship.__dict__}}
        )
    join_table = str(join_table) if join_table else None

    return RelationshipWithJoinTable(
        **{**{'join_table': join_table, **relationship.__dict__}}
    )
