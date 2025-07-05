import { LinkObj } from './link-obj';

xdescribe('LinkObj', () => {
  it('should create an instance', () => {
    expect(new LinkObj('', '')).toBeTruthy();
  });
});
