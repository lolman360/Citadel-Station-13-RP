/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { canRender, classes } from 'common/react';
import { computeBoxClassName, computeBoxProps } from './Box';
import { Icon } from './Icon';

export const LayeredTabs = props => {
  const {
    className,
    fill,
    fluid,
    children,
    ...rest
  } = props;
  return (
    <div
      className={classes([
        'Tabs',
        'Tabs--vertical',
        fill && 'Tabs--fill',
        fluid && 'Tabs--fluid',
        className,
        computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}>
      {children}
    </div>
  );
};

const LayeredTab = props => {
  const {
    className,
    tabText,
    selected,
    color,
    icon,
    leftSlot,
    rightSlot,
    children,
    ...rest
  } = props;
  return (
    <div
      className={classes([
        'Tab',
        'Tabs__Tab',
        'Tab--color--' + color,
        selected && 'Tab--selected',
        className,
        ...computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}>
      {canRender(leftSlot) && (
        <div className="Tab__left">
          {leftSlot}
        </div>
      ) || !!icon && (
        <div className="Tab__left">
          <Icon name={icon} />
        </div>
      )}
      <div className="Tab__text">
        {tabText}
      </div>
      {canRender(rightSlot) && (
        <div className="Tab__right">
          {rightSlot}
        </div>
      )}
      {selected && (
        <div className="LayeredTab__subtab">
          {children}
        </div>
      )}
    </div>
  );
};

LayeredTabs.LayeredTab = LayeredTab;
